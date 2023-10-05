import 'dart:async';

import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/message_repository_impl.dart';
import 'package:runnoter/domain/entity/message.dart';

import '../../creators/chat_dto_creator.dart';
import '../../creators/message_creator.dart';
import '../../creators/message_dto_creator.dart';
import '../../mock/firebase/mock_firebase_chat_service.dart';
import '../../mock/firebase/mock_firebase_message_service.dart';

void main() {
  final dbMessageService = MockFirebaseMessageService();
  final dbChatService = MockFirebaseChatService();
  late MessageRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseMessageService>(
      () => dbMessageService,
    );
    GetIt.I.registerFactory<firebase.FirebaseChatService>(() => dbChatService);
  });

  setUp(() => repository = MessageRepositoryImpl());

  tearDown(() {
    reset(dbMessageService);
    reset(dbChatService);
  });

  test(
    'loadMessageById, '
    'message exists in repo, '
    'should return message from repo',
    () async {
      final Message expectedMessage = createMessage(id: 'm3');
      final List<Message> existingMessages = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
        expectedMessage,
        createMessage(id: 'm4'),
      ];
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Message? message =
          await repository.loadMessageById(messageId: 'm3');

      expect(message, expectedMessage);
    },
  );

  test(
    'loadMessageById, '
    'message does not exist in repo, '
    'should load message from db add it to repo and return it',
    () async {
      final firebase.MessageDto expectedMessageDto = createMessageDto(id: 'm3');
      final Message expectedMessage = createMessage(id: 'm3');
      final List<Message> existingMessages = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
        createMessage(id: 'm4'),
      ];
      dbMessageService.mockLoadMessageById(messageDto: expectedMessageDto);
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Message? message =
          await repository.loadMessageById(messageId: 'm3');

      expect(message, expectedMessage);
      expect(
        repository.dataStream$,
        emitsInOrder([
          [...existingMessages, expectedMessage]
        ]),
      );
    },
  );

  test(
    'getMessagesForChat, '
    'should load latest messages from db, add them to repo and '
    'should listen and emit all existing and newly added messages with matching chat id',
    () async {
      const String chatId = 'c1';
      final List<Message> existingMessages = [
        createMessage(id: 'm1', chatId: chatId, text: 'text1'),
        createMessage(id: 'm2', chatId: 'c2', text: 'text2'),
        createMessage(id: 'm3', chatId: chatId, text: 'text3'),
      ];
      final List<firebase.MessageDto> loadedMessageDtos = [
        createMessageDto(id: 'm4', chatId: chatId, text: 'text4'),
        createMessageDto(id: 'm5', chatId: chatId, text: 'text5'),
      ];
      final List<Message> loadedMessages = [
        createMessage(id: 'm4', chatId: chatId, text: 'text4'),
        createMessage(id: 'm5', chatId: chatId, text: 'text5'),
      ];
      final firebase.MessageDto firstAddedMessageDto =
          createMessageDto(id: 'm6', chatId: chatId, text: 'text6');
      final firebase.MessageDto secondAddedMessageDto =
          createMessageDto(id: 'm7', chatId: chatId, text: 'text7');
      final firebase.MessageDto modifiedMessageDto = createMessageDto(
        id: 'm1',
        chatId: chatId,
        text: 'modified text 1',
      );
      final Message firstAddedMessage =
          createMessage(id: 'm6', chatId: chatId, text: 'text6');
      final Message secondAddedMessage =
          createMessage(id: 'm7', chatId: chatId, text: 'text7');
      final Message modifiedMessage = createMessage(
        id: 'm1',
        chatId: chatId,
        text: 'modified text 1',
      );
      final StreamController<List<firebase.MessageDto>>
          addedOrModifiedMessages$ = StreamController()..add([]);
      dbMessageService.mockLoadMessagesForChat(
        messageDtos: loadedMessageDtos,
      );
      dbMessageService.mockGetAddedOrModifiedMessagesForChat(
        messageDtosStream: addedOrModifiedMessages$.stream,
      );
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Stream<List<Message>?> messages$ =
          repository.getMessagesForChat(chatId: chatId);
      addedOrModifiedMessages$.add([firstAddedMessageDto]);
      addedOrModifiedMessages$.add([secondAddedMessageDto, modifiedMessageDto]);

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
            modifiedMessage,
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
            modifiedMessage,
            existingMessages[1],
            existingMessages.last,
            ...loadedMessages,
            firstAddedMessage,
            secondAddedMessage,
          ],
        ]),
      );
    },
  );

  test(
    'getMessagesForChat, '
    'should emit empty list if there are no messages in repo',
    () async {
      const String chatId = 'c1';
      dbMessageService.mockLoadMessagesForChat(messageDtos: const []);
      dbMessageService.mockGetAddedOrModifiedMessagesForChat(
        messageDtosStream: Stream.value(const []),
      );

      final Stream<List<Message>?> messages$ =
          repository.getMessagesForChat(chatId: chatId);

      expect(messages$, emits(const []));
    },
  );

  test(
    'doesUserHaveUnreadMessagesInChat, '
    'at least one unread message sent by second user exists in repo, '
    'should return true',
    () {
      const String chatId = 'c1';
      const String userId = 'u1';
      final List<Message> existingMessages = [
        createMessage(
          id: 'm1',
          chatId: chatId,
          senderId: 'u2',
          status: MessageStatus.read,
        ),
        createMessage(
          id: 'm2',
          chatId: 'c2',
          senderId: 'u2',
          status: MessageStatus.sent,
        ),
        createMessage(
          id: 'm3',
          chatId: chatId,
          senderId: userId,
          status: MessageStatus.sent,
        ),
        createMessage(
          id: 'm3',
          chatId: chatId,
          senderId: 'u2',
          status: MessageStatus.sent,
        ),
      ];
      dbChatService.mockGetChatById(
        chatDtoStream: Stream.value(
          createChatDto(id: 'c1', user1Id: 'u2', user2Id: userId),
        ),
      );
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Stream<bool> result$ = repository.doesUserHaveUnreadMessagesInChat(
        chatId: chatId,
        userId: userId,
      );

      expect(result$, emits(true));
    },
  );

  test(
    'doesUserHaveUnreadMessagesInChat, '
    'no one unread message sent by second user exists in repo, '
    'should listen to unread messages in db',
    () async {
      const String chatId = 'c1';
      const String userId = 'u1';
      final List<Message> existingMessages = [
        createMessage(
          id: 'm1',
          chatId: chatId,
          senderId: 'u2',
          status: MessageStatus.read,
        ),
        createMessage(
          id: 'm2',
          chatId: 'c2',
          senderId: 'u2',
          status: MessageStatus.sent,
        ),
        createMessage(
          id: 'm3',
          chatId: chatId,
          senderId: userId,
          status: MessageStatus.sent,
        ),
      ];
      final StreamController<bool> expected$ = StreamController()..add(false);
      dbChatService.mockGetChatById(
        chatDtoStream: Stream.value(
          createChatDto(id: 'c1', user1Id: 'u2', user2Id: userId),
        ),
      );
      dbMessageService.mockAreThereUnreadMessagesInChatSentByUser$(
        expected$: expected$.stream,
      );
      repository = MessageRepositoryImpl(initialData: existingMessages);

      final Stream<bool> result$ = repository.doesUserHaveUnreadMessagesInChat(
        chatId: chatId,
        userId: userId,
      );
      expected$.add(true);

      expect(result$, emitsInOrder([false, true]));
      await repository.dataStream$.first;
      verify(
        () => dbMessageService.areThereUnreadMessagesInChatSentByUser$(
          chatId: chatId,
          userId: 'u2',
        ),
      ).called(1);
    },
  );

  test(
    'loadOlderMessagesForChat, '
    "should call db message service's method to load older messages and "
    'should add loaded messages to repo',
    () async {
      const String chatId = 'c1';
      const String lastVisibleMessageId = 'm1';
      final List<Message> existingMessages = [
        createMessage(id: 'm1', chatId: chatId, text: 'text1'),
        createMessage(id: 'm2', chatId: chatId, text: 'text2'),
      ];
      final List<firebase.MessageDto> loadedMessageDtos = [
        createMessageDto(id: 'm3', chatId: chatId, text: 'text3'),
        createMessageDto(id: 'm4', chatId: chatId, text: 'text4'),
      ];
      final List<Message> loadedMessages = [
        createMessage(id: 'm3', chatId: chatId, text: 'text3'),
        createMessage(id: 'm4', chatId: chatId, text: 'text4'),
      ];
      dbMessageService.mockLoadMessagesForChat(
        messageDtos: loadedMessageDtos,
      );
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
        () => dbMessageService.loadMessagesForChat(
          chatId: chatId,
          lastVisibleMessageId: lastVisibleMessageId,
        ),
      ).called(1);
    },
  );

  test(
    'addMessage, '
    'should call db storage service method to upload images and '
    'should call db message service method to add message to chat and '
    'should add new message to repo',
    () async {
      const String messageId = 'm3';
      const String chatId = 'c1';
      const String senderId = 's1';
      final DateTime dateTime = DateTime(2023, 1, 1);
      const String text = 'message';
      final firebase.MessageDto addedMessageDto = firebase.MessageDto(
        id: messageId,
        status: firebase.MessageStatus.sent,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      final Message addedMessage = Message(
        id: messageId,
        status: MessageStatus.sent,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
      final List<Message> existingMessages = [
        createMessage(id: 'm1'),
        createMessage(id: 'm2'),
      ];
      dbMessageService.mockAddMessage(addedMessageDto: addedMessageDto);
      repository = MessageRepositoryImpl(initialData: existingMessages);

      await repository.addMessage(
        status: MessageStatus.sent,
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
        () => dbMessageService.addMessage(
          status: firebase.MessageStatus.sent,
          chatId: chatId,
          senderId: senderId,
          dateTime: dateTime,
          text: text,
        ),
      ).called(1);
    },
  );

  test(
    'markMessagesAsRead, '
    'for each message id should call db method to update message status to read and '
    'should update these messages in repo',
    () async {
      final List<Message> existingMessages = [
        createMessage(id: 'm1', status: MessageStatus.sent),
        createMessage(id: 'm2', status: MessageStatus.read),
        createMessage(id: 'm3', status: MessageStatus.sent),
      ];
      final firebase.MessageDto firstUpdatedMessageDto =
          createMessageDto(id: 'm1', status: firebase.MessageStatus.read);
      final firebase.MessageDto secondUpdatedMessageDto =
          createMessageDto(id: 'm3', status: firebase.MessageStatus.read);
      when(
        () => dbMessageService.updateMessageStatus(
          messageId: 'm1',
          status: firebase.MessageStatus.read,
        ),
      ).thenAnswer((_) => Future.value(firstUpdatedMessageDto));
      when(
        () => dbMessageService.updateMessageStatus(
          messageId: 'm3',
          status: firebase.MessageStatus.read,
        ),
      ).thenAnswer((_) => Future.value(secondUpdatedMessageDto));
      repository = MessageRepositoryImpl(initialData: existingMessages);

      await repository.markMessagesAsRead(messageIds: ['m1', 'm3']);

      expect(
        repository.dataStream$,
        emits([
          createMessage(id: 'm1', status: MessageStatus.read),
          existingMessages[1],
          createMessage(id: 'm3', status: MessageStatus.read),
        ]),
      );
      verify(
        () => dbMessageService.updateMessageStatus(
          messageId: 'm1',
          status: firebase.MessageStatus.read,
        ),
      ).called(1);
      verify(
        () => dbMessageService.updateMessageStatus(
          messageId: 'm3',
          status: firebase.MessageStatus.read,
        ),
      ).called(1);
    },
  );

  test(
    'delete all messages from chat, '
    'should delete all messages with matching chat id from db and from repo',
    () async {
      const String chatId = 'c1';
      final List<Message> existingMessages = [
        createMessage(id: 'm11', chatId: chatId),
        createMessage(id: 'm21', chatId: 'c2'),
        createMessage(id: 'm12', chatId: chatId),
        createMessage(id: 'm13', chatId: chatId),
        createMessage(id: 'm22', chatId: 'c2'),
      ];
      dbMessageService.mockDeleteAllMessagesFromChat();
      repository = MessageRepositoryImpl(initialData: existingMessages);

      await repository.deleteAllMessagesFromChat(chatId: chatId);

      expect(
        repository.dataStream$,
        emits([existingMessages[1], existingMessages.last]),
      );
      verify(
        () => dbMessageService.deleteAllMessagesFromChat(chatId: chatId),
      ).called(1);
    },
  );
}
