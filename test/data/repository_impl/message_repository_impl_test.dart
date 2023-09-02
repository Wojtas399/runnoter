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
}
