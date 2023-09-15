import 'dart:async';
import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/message_repository_impl.dart';
import 'package:runnoter/domain/entity/message.dart';

import '../../creators/message_creator.dart';
import '../../creators/message_dto_creator.dart';
import '../../mock/firebase/mock_firebase_message_service.dart';
import '../../mock/firebase/mock_firebase_storage_service.dart';

void main() {
  final firebaseMessageService = MockFirebaseMessageService();
  final firebaseStorageService = MockFirebaseStorageService();
  late MessageRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseMessageService>(
      () => firebaseMessageService,
    );
    GetIt.I.registerFactory<FirebaseStorageService>(
      () => firebaseStorageService,
    );
  });

  setUp(() => repository = MessageRepositoryImpl());

  tearDown(() {
    reset(firebaseMessageService);
    reset(firebaseStorageService);
  });

  test(
    'get messages for chat, '
    'should load latest messages from db, add them to repo and '
    'should listen and emit all existing and newly added messages with matching chat id',
    () async {
      const String chatId = 'c1';
      final List<Message> existingMessages = [
        createMessage(id: 'm1', chatId: chatId),
        createMessage(id: 'm2', chatId: 'c2'),
        createMessage(id: 'm3', chatId: chatId),
      ];
      final List<MessageDto> loadedMessageDtos = [
        createMessageDto(
          id: 'm4',
          chatId: chatId,
          images: const [
            MessageImageDto(id: 'i1', order: 1),
            MessageImageDto(id: 'i2', order: 2),
          ],
        ),
        createMessageDto(id: 'm5', chatId: chatId),
      ];
      final List<Message> loadedMessages = [
        createMessage(
          id: 'm4',
          chatId: chatId,
          images: [
            MessageImage(id: 'i1', order: 1, bytes: Uint8List(1)),
            MessageImage(id: 'i2', order: 2, bytes: Uint8List(2)),
          ],
        ),
        createMessage(id: 'm5', chatId: chatId),
      ];
      final MessageDto firstAddedMessageDto =
          createMessageDto(id: 'm6', chatId: chatId);
      final MessageDto secondAddedMessageDto = createMessageDto(
        id: 'm7',
        chatId: chatId,
        images: const [MessageImageDto(id: 'i3', order: 1)],
      );
      final Message firstAddedMessage = createMessage(id: 'm6', chatId: chatId);
      final Message secondAddedMessage = createMessage(
        id: 'm7',
        chatId: chatId,
        images: [MessageImage(id: 'i3', order: 1, bytes: Uint8List(3))],
      );
      final StreamController<List<MessageDto>> addedMessages$ =
          StreamController()..add([]);
      firebaseMessageService.mockLoadMessagesForChat(
        messageDtos: loadedMessageDtos,
      );
      firebaseMessageService.mockGetAddedMessagesForChat(
        addedMessageDtosStream: addedMessages$.stream,
      );
      when(
        () => firebaseStorageService.loadChatImage(
          chatId: chatId,
          imageId: 'i1',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(1)));
      when(
        () => firebaseStorageService.loadChatImage(
          chatId: chatId,
          imageId: 'i2',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(2)));
      when(
        () => firebaseStorageService.loadChatImage(
          chatId: chatId,
          imageId: 'i3',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(3)));
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Stream<List<Message>?> messages$ =
          repository.getMessagesForChat(chatId: chatId);
      addedMessages$.add([firstAddedMessageDto]);
      addedMessages$.add([secondAddedMessageDto]);

      expect(
        messages$,
        emitsInOrder([
          [existingMessages.first, existingMessages.last, ...loadedMessages],
          [
            existingMessages.first,
            existingMessages.last,
            ...loadedMessages,
            firstAddedMessage,
          ],
          [
            existingMessages.first,
            existingMessages.last,
            ...loadedMessages,
            firstAddedMessage,
            secondAddedMessage,
          ],
        ]),
      );
      expect(
        repository.dataStream$,
        emitsInOrder([
          existingMessages,
          [...existingMessages, ...loadedMessages],
          [...existingMessages, ...loadedMessages, firstAddedMessage],
          [
            ...existingMessages,
            ...loadedMessages,
            firstAddedMessage,
            secondAddedMessage,
          ],
        ]),
      );
    },
  );

  test(
    'load older messages for chat, '
    "should call firebase message service's method to load older messages and "
    'should add loaded messages to repo',
    () async {
      const String chatId = 'c1';
      const String lastVisibleMessageId = 'm1';
      final List<Message> existingMessages = [
        createMessage(id: 'm1', chatId: chatId),
        createMessage(id: 'm2', chatId: chatId),
      ];
      final List<MessageDto> loadedMessageDtos = [
        createMessageDto(id: 'm3', chatId: chatId),
        createMessageDto(
          id: 'm4',
          chatId: chatId,
          images: const [MessageImageDto(id: 'i1', order: 1)],
        ),
      ];
      final List<Message> loadedMessages = [
        createMessage(id: 'm3', chatId: chatId),
        createMessage(
          id: 'm4',
          chatId: chatId,
          images: [MessageImage(id: 'i1', order: 1, bytes: Uint8List(1))],
        ),
      ];
      firebaseMessageService.mockLoadMessagesForChat(
        messageDtos: loadedMessageDtos,
      );
      firebaseStorageService.mockLoadChatImage(imageData: Uint8List(1));
      repository = MessageRepositoryImpl(initialData: existingMessages);

      await repository.loadOlderMessagesForChat(
        chatId: chatId,
        lastVisibleMessageId: lastVisibleMessageId,
      );

      expect(
        repository.dataStream$,
        emitsInOrder([
          [...existingMessages, ...loadedMessages],
        ]),
      );
      verify(
        () => firebaseMessageService.loadMessagesForChat(
          chatId: chatId,
          lastVisibleMessageId: lastVisibleMessageId,
        ),
      ).called(1);
      verify(
        () => firebaseStorageService.loadChatImage(
          chatId: chatId,
          imageId: 'i1',
        ),
      ).called(1);
    },
  );

  test(
    'add message to chat, '
    'should call firebase storage service method to upload images and '
    'should call firebase message service method to add message to chat and '
    'should add new message to repo',
    () async {
      const String messageId = 'm3';
      const String chatId = 'c1';
      const String senderId = 's1';
      final DateTime dateTime = DateTime(2023, 1, 1);
      const String text = 'message';
      final List<MessageImage> images = [
        MessageImage(id: 'i1', order: 1, bytes: Uint8List(1)),
        MessageImage(id: 'i2', order: 2, bytes: Uint8List(2)),
      ];
      const List<MessageImageDto> imageDtos = [
        MessageImageDto(
          id: 'i1',
          order: 1,
        ),
        MessageImageDto(
          id: 'i2',
          order: 2,
        ),
      ];
      final MessageDto addedMessageDto = MessageDto(
        id: messageId,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
        images: imageDtos,
      );
      final Message addedMessage = Message(
        id: messageId,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
        images: images,
      );
      final List<Message> existingMessages = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
      ];
      when(
        () => firebaseStorageService.uploadChatImage(
          chatId: chatId,
          imageBytes: Uint8List(1),
        ),
      ).thenAnswer((_) => Future.value('i1'));
      when(
        () => firebaseStorageService.uploadChatImage(
          chatId: chatId,
          imageBytes: Uint8List(2),
        ),
      ).thenAnswer((_) => Future.value('i2'));
      firebaseMessageService.mockAddMessageToChat(
        addedMessageDto: addedMessageDto,
      );
      repository = MessageRepositoryImpl(initialData: existingMessages);

      await repository.addMessageToChat(
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
        images: images,
      );

      expect(
        repository.dataStream$,
        emitsInOrder([
          [...existingMessages, addedMessage],
        ]),
      );
      verify(
        () => firebaseStorageService.uploadChatImage(
          chatId: chatId,
          imageBytes: Uint8List(1),
        ),
      ).called(1);
      verify(
        () => firebaseStorageService.uploadChatImage(
          chatId: chatId,
          imageBytes: Uint8List(2),
        ),
      ).called(1);
      verify(
        () => firebaseMessageService.addMessageToChat(
          chatId: chatId,
          senderId: senderId,
          dateTime: dateTime,
          text: text,
          images: imageDtos,
        ),
      ).called(1);
    },
  );
}
