import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/message_repository_impl.dart';
import 'package:runnoter/domain/entity/message.dart';

import '../../creators/message_creator.dart';
import '../../creators/message_dto_creator.dart';
import '../../mock/firebase/mock_firebase_message_service.dart';

void main() {
  final firebaseMessageService = MockFirebaseMessageService();
  late MessageRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseMessageService>(
      () => firebaseMessageService,
    );
  });

  setUp(() => repository = MessageRepositoryImpl());

  tearDown(() {
    reset(firebaseMessageService);
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
        createMessageDto(id: 'm4', chatId: chatId),
        createMessageDto(id: 'm5', chatId: chatId),
      ];
      final List<Message> loadedMessages = [
        createMessage(id: 'm4', chatId: chatId),
        createMessage(id: 'm5', chatId: chatId),
      ];
      final MessageDto firstAddedMessageDto =
          createMessageDto(id: 'm6', chatId: chatId);
      final MessageDto secondAddedMessageDto =
          createMessageDto(id: 'm7', chatId: chatId);
      final Message firstAddedMessage = createMessage(id: 'm6', chatId: chatId);
      final Message secondAddedMessage =
          createMessage(id: 'm7', chatId: chatId);
      final StreamController<List<MessageDto>> addedMessages$ =
          StreamController()..add([]);
      firebaseMessageService.mockLoadMessagesForChat(
        messageDtos: loadedMessageDtos,
      );
      firebaseMessageService.mockGetAddedMessagesForChat(
        addedMessageDtosStream: addedMessages$.stream,
      );
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Stream<List<Message>?> messages$ =
          repository.getMessagesForChat(chatId: chatId);
      addedMessages$.add([firstAddedMessageDto]);
      addedMessages$.add([secondAddedMessageDto]);

      expect(
        messages$,
        emitsInOrder([
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
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
      ];
      final List<MessageDto> loadedMessageDtos = [
        createMessageDto(id: 'm3'),
        createMessageDto(id: 'm4'),
      ];
      final List<Message> loadedMessages = [
        createMessage(id: 'm3'),
        createMessage(id: 'm4'),
      ];
      repository = MessageRepositoryImpl(initialData: existingMessages);
      firebaseMessageService.mockLoadMessagesForChat(
        messageDtos: loadedMessageDtos,
      );

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
    },
  );

  test(
    'add message to chat, '
    "should call firebase message service's method to add message to chat and "
    'should add this new message to repo',
    () async {
      const String messageId = 'm3';
      const String chatId = 'c1';
      const String senderId = 's1';
      final DateTime dateTime = DateTime(2023, 1, 1);
      const String text = 'message';
      final MessageDto addedMessageDto = MessageDto(
        id: messageId,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      final Message addedMessage = Message(
        id: messageId,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      //TODO: Add images
      final List<Message> existingMessages = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
      ];
      firebaseMessageService.mockAddMessageToChat(
        addedMessageDto: addedMessageDto,
      );
      repository = MessageRepositoryImpl(initialData: existingMessages);

      await repository.addMessageToChat(
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );

      expect(
        repository.dataStream$,
        emitsInOrder([
          [...existingMessages, addedMessage],
        ]),
      );
      verify(
        () => firebaseMessageService.addMessageToChat(
          chatId: chatId,
          senderId: senderId,
          dateTime: dateTime,
          text: text,
        ),
      ).called(1);
    },
  );
}
