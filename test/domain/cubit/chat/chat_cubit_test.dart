import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/data/entity/chat.dart';
import 'package:runnoter/data/entity/message.dart';
import 'package:runnoter/data/entity/message_image.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/domain/cubit/chat/chat_cubit.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';
import 'package:runnoter/domain/repository/message_image_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:rxdart/rxdart.dart';

import '../../../creators/chat_creator.dart';
import '../../../creators/message_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_chat_repository.dart';
import '../../../mock/domain/repository/mock_message_image_repository.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  final messageImageRepository = MockMessageImageRepository();
  final personRepository = MockPersonRepository();
  final dateService = MockDateService();
  const String chatId = 'c1';
  const String loggedUserId = 'u1';

  ChatCubit createCubit({
    List<ChatMessage>? messagesFromLatest,
    String? messageToSend,
    List<Uint8List> imagesToSend = const [],
  }) =>
      ChatCubit(
        chatId: chatId,
        initialState: ChatState(
          messagesFromLatest: messagesFromLatest,
          messageToSend: messageToSend,
          imagesToSend: imagesToSend,
        ),
      );

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
    GetIt.I.registerSingleton<MessageImageRepository>(messageImageRepository);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<DateService>(() => dateService);
  });

  tearDown(() {
    reset(authService);
    reset(chatRepository);
    reset(messageRepository);
    reset(messageImageRepository);
    reset(personRepository);
    reset(dateService);
  });

  group(
    'initializeChatListener',
    () {
      final DateTime now = DateTime(2023, 1, 1, 10, 30);
      final Chat chat = createChat(
        id: 'c1',
        user1Id: 'u2',
        user2Id: loggedUserId,
        user1LastTypingDateTime: now.subtract(const Duration(seconds: 6)),
        user2LastTypingDateTime: now.subtract(const Duration(seconds: 2)),
      );
      final Chat updatedChat = createChat(
        id: 'c1',
        user1Id: 'u2',
        user2Id: loggedUserId,
        user1LastTypingDateTime: now.subtract(const Duration(seconds: 2)),
        user2LastTypingDateTime: now.subtract(const Duration(seconds: 6)),
      );
      final Person recipient = createPerson(
        id: 'u2',
        name: 'name',
        surname: 'surname',
      );
      final StreamController<Chat> chat$ = StreamController()..add(chat);

      blocTest(
        'Should set listener of chat. '
        'Should load recipient full name. '
        'Should check if recipient is typing (if last typing date time is '
        'within 5 seconds of now date should set isRecipientTyping param '
        'to true else to false).'
        'If chat is not updated for 5 seconds it should automatically set '
        'isRecipientTyping param to false.',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          chatRepository.mockGetChatById(chatStream: chat$.stream);
          dateService.mockGetNow(now: now);
          personRepository.mockGetPersonById(person: recipient);
        },
        act: (cubit) {
          cubit.initializeChatListener();
          chat$.add(updatedChat);
        },
        wait: const Duration(seconds: 6),
        expect: () => [
          const ChatState(
            recipientFullName: 'name surname',
            isRecipientTyping: false,
          ),
          const ChatState(
            recipientFullName: 'name surname',
            isRecipientTyping: true,
          ),
          const ChatState(
            recipientFullName: 'name surname',
            isRecipientTyping: false,
          ),
        ],
        verify: (_) => verify(
          () => chatRepository.getChatById(chatId: chatId),
        ).called(1),
      );
    },
  );

  group(
    'initializeMessagesListener',
    () {
      final List<Message> messages = [
        createMessage(
          id: 'm1',
          status: MessageStatus.sent,
          text: 'message 1',
          senderId: loggedUserId,
          dateTime: DateTime(2023, 1, 10),
        ),
        createMessage(
          id: 'm2',
          status: MessageStatus.sent,
          text: 'message 2',
          senderId: 'u2',
          dateTime: DateTime(2023, 1, 5, 10, 30),
        ),
        createMessage(
          id: 'm3',
          status: MessageStatus.sent,
          text: 'message 3',
          senderId: 'u2',
          dateTime: DateTime(2023, 1, 5, 9, 30),
        ),
        createMessage(
          id: 'm4',
          status: MessageStatus.read,
          text: 'message 4',
          senderId: 'u2',
          dateTime: DateTime(2023, 1, 5, 9),
        ),
        createMessage(
          id: 'm5',
          status: MessageStatus.read,
          text: 'message 5',
          senderId: loggedUserId,
          dateTime: DateTime(2023, 1, 5, 8),
        ),
      ];
      final List<Message> updatedMessages = [
        messages.first,
        messages[1].copyWithStatus(MessageStatus.read),
        messages[2].copyWithStatus(MessageStatus.read),
        messages[3],
        messages.last,
      ];
      final List<MessageImage> m1MessageImages = [
        MessageImage(id: 'i2', messageId: 'm2', order: 2, bytes: Uint8List(2)),
        MessageImage(id: 'i1', messageId: 'm1', order: 1, bytes: Uint8List(1)),
      ];
      final List<ChatMessage> expectedMessages = [
        ChatMessage(
          id: 'm1',
          status: MessageStatus.sent,
          hasBeenSentByLoggedUser: true,
          dateTime: DateTime(2023, 1, 10),
          text: 'message 1',
          images: m1MessageImages.reversed.toList(),
        ),
        ChatMessage(
          id: 'm2',
          status: MessageStatus.sent,
          hasBeenSentByLoggedUser: false,
          dateTime: DateTime(2023, 1, 5, 10, 30),
          text: 'message 2',
          images: const [],
        ),
        ChatMessage(
          id: 'm3',
          status: MessageStatus.sent,
          hasBeenSentByLoggedUser: false,
          dateTime: DateTime(2023, 1, 5, 9, 30),
          text: 'message 3',
          images: const [],
        ),
        ChatMessage(
          id: 'm4',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: false,
          dateTime: DateTime(2023, 1, 5, 9),
          text: 'message 4',
          images: const [],
        ),
        ChatMessage(
          id: 'm5',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          dateTime: DateTime(2023, 1, 5, 8),
          text: 'message 5',
          images: const [],
        ),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);
      final StreamController<List<MessageImage>> m1MessageImages$ =
          BehaviorSubject.seeded(m1MessageImages);

      blocTest(
        'Should set listener of messages with images. '
        'Should call message repository method to mark messages sent by recipient as read. '
        'Should sort messages descending by date and images ascending by order.',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          messageRepository.mockGetMessagesForChat(
            messagesStream: messages$.stream,
          );
          messageRepository.mockMarkMessagesAsRead();
          messageImageRepository.mockGetImagesByMessageId(
            imagesStream: BehaviorSubject.seeded(const []),
          );
          when(
            () => messageImageRepository.getImagesByMessageId(messageId: 'm1'),
          ).thenAnswer((_) => m1MessageImages$.stream);
        },
        act: (cubit) async {
          cubit.initializeMessagesListener();
          await cubit.stream.first;
          messages$.add(updatedMessages);
          await cubit.stream.first;
          m1MessageImages$.add([]);
          await cubit.stream.first;
          messages$.add(const []);
        },
        expect: () => [
          ChatState(messagesFromLatest: expectedMessages),
          ChatState(
            messagesFromLatest: [
              expectedMessages.first,
              expectedMessages[1].copyWith(status: MessageStatus.read),
              expectedMessages[2].copyWith(status: MessageStatus.read),
              expectedMessages[3],
              expectedMessages[4],
            ],
          ),
          ChatState(
            messagesFromLatest: [
              expectedMessages.first.copyWith(images: []),
              expectedMessages[1].copyWith(status: MessageStatus.read),
              expectedMessages[2].copyWith(status: MessageStatus.read),
              expectedMessages[3],
              expectedMessages[4],
            ],
          ),
          const ChatState(messagesFromLatest: []),
        ],
        verify: (_) {
          verify(
            () => messageRepository.getMessagesForChat(chatId: 'c1'),
          ).called(1);
          verify(
            () => messageRepository.markMessagesAsRead(
              messageIds: ['m2', 'm3'],
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'messageChanged, '
    'Should update message to send in state. '
    'Should set interval to 2s to call chat repository method to update chat with '
    'updated logged user typing date time.'
    'After some time of inactivity should cancel interval.',
    build: () => createCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      chatRepository.mockGetChatById(
        chat: createChat(user1Id: 'u2', user2Id: loggedUserId),
      );
      dateService.mockGetNow(now: DateTime(2023));
      chatRepository.mockUpdateChat();
    },
    act: (cubit) async {
      cubit.messageChanged('msg');
      await Future.delayed(const Duration(seconds: 2));
      cubit.messageChanged('message');
    },
    wait: const Duration(seconds: 5),
    expect: () => [
      const ChatState(messageToSend: 'msg'),
      const ChatState(messageToSend: 'message'),
    ],
    verify: (_) {
      verify(
        () => chatRepository.updateChat(
          chatId: chatId,
          user2LastTypingDateTime: DateTime(2023),
        ),
      ).called(4);
    },
  );

  blocTest(
    'addImagesToSend, '
    'should add new images to list',
    build: () => createCubit(
      imagesToSend: [Uint8List(1)],
    ),
    act: (cubit) => cubit.addImagesToSend([Uint8List(2), Uint8List(3)]),
    expect: () => [
      ChatState(imagesToSend: [Uint8List(1), Uint8List(2), Uint8List(3)]),
    ],
  );

  blocTest(
    'deleteImageToSend, '
    'index does not match to list indexes, '
    'should do nothing',
    build: () => createCubit(
      imagesToSend: [Uint8List(1), Uint8List(2), Uint8List(3)],
    ),
    act: (cubit) => cubit.deleteImageToSend(3),
    expect: () => [],
  );

  blocTest(
    'deleteImageToSend, '
    'should delete image from list at given index',
    build: () => createCubit(
      imagesToSend: [Uint8List(1), Uint8List(2), Uint8List(3)],
    ),
    act: (cubit) => cubit.deleteImageToSend(1),
    expect: () => [
      ChatState(imagesToSend: [Uint8List(1), Uint8List(3)]),
    ],
  );

  blocTest(
    'submitMessage, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createCubit(messageToSend: 'message'),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.submitMessage(),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'submitMessage, '
    'there are no images to send, '
    'Should call chat repository method to update chat with logged user typing '
    'dateTime downgraded by 5 min. '
    'Should call message repository method to add new message with current '
    'dateTime and sent status.'
    'Should set messageToSend as null.',
    build: () => createCubit(messageToSend: 'message', imagesToSend: []),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      chatRepository.mockGetChatById(
        chat: createChat(user1Id: loggedUserId, user2Id: 'u2'),
      );
      chatRepository.mockUpdateChat();
      messageRepository.mockAddMessage(addedMessageId: 'm1');
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(messageToSend: null, imagesToSend: []),
    ],
    verify: (_) {
      verify(
        () => chatRepository.updateChat(
          chatId: chatId,
          user1LastTypingDateTime: DateTime(2023, 1, 1, 12, 25),
        ),
      ).called(1);
      verify(
        () => messageRepository.addMessage(
          status: MessageStatus.sent,
          chatId: chatId,
          senderId: loggedUserId,
          dateTime: DateTime(2023, 1, 1, 12, 30),
          text: 'message',
        ),
      ).called(1);
    },
  );

  blocTest(
    'submitMessage, '
    'Should call chat repository method to update chat with logged user typing '
    'dateTime downgraded by 5 min. '
    'Should call message repository method to add new message with current '
    'dateTime and sent status. '
    'Should call message image repository to add images to message. '
    'Should set messageToSend as null and imagesToSend as empty array.',
    build: () => createCubit(
      messageToSend: 'message',
      imagesToSend: [Uint8List(1), Uint8List(2)],
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      chatRepository.mockGetChatById(
        chat: createChat(user1Id: loggedUserId, user2Id: 'u2'),
      );
      chatRepository.mockUpdateChat();
      messageRepository.mockAddMessage(addedMessageId: 'm1');
      messageImageRepository.mockAddImagesInOrderToMessage();
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(messageToSend: null, imagesToSend: []),
    ],
    verify: (_) {
      verify(
        () => chatRepository.updateChat(
          chatId: chatId,
          user1LastTypingDateTime: DateTime(2023, 1, 1, 12, 25),
        ),
      ).called(1);
      verify(
        () => messageRepository.addMessage(
          status: MessageStatus.sent,
          chatId: chatId,
          senderId: loggedUserId,
          dateTime: DateTime(2023, 1, 1, 12, 30),
          text: 'message',
        ),
      ).called(1);
      verify(
        () => messageImageRepository.addImagesInOrderToMessage(
          messageId: 'm1',
          bytesOfImages: [Uint8List(1), Uint8List(2)],
        ),
      ).called(1);
    },
  );

  blocTest(
    'loadOlderMessages, '
    'messages list is null, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => messageRepository.mockLoadOlderMessagesForChat(),
    act: (cubit) => cubit.loadOlderMessages(),
    expect: () => [],
    verify: (_) => verifyNever(
      () => messageRepository.loadOlderMessagesForChat(
        chatId: chatId,
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ),
  );

  blocTest(
    'loadOlderMessages, '
    'messages list is empty, '
    'should do nothing',
    build: () => createCubit(),
    setUp: () => messageRepository.mockLoadOlderMessagesForChat(),
    act: (cubit) => cubit.loadOlderMessages(),
    expect: () => [],
    verify: (_) => verifyNever(
      () => messageRepository.loadOlderMessagesForChat(
        chatId: chatId,
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ),
  );

  blocTest(
    'loadOlderMessages, '
    'should call message repository method to load older messages with id of the oldest message in state',
    build: () => createCubit(
      messagesFromLatest: [
        ChatMessage(
          id: 'm1',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          dateTime: DateTime(2023, 1, 2),
        ),
        ChatMessage(
          id: 'm2',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: false,
          dateTime: DateTime(2023, 1, 5),
        ),
        ChatMessage(
          id: 'm3',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          dateTime: DateTime(2023, 1, 10),
        ),
      ],
    ),
    setUp: () => messageRepository.mockLoadOlderMessagesForChat(),
    act: (cubit) => cubit.loadOlderMessages(),
    expect: () => [],
    verify: (_) => verify(
      () => messageRepository.loadOlderMessagesForChat(
        chatId: chatId,
        lastVisibleMessageId: 'm3',
      ),
    ).called(1),
  );
}

extension _ChatMessageExtension on ChatMessage {
  ChatMessage copyWith({
    MessageStatus? status,
    List<MessageImage>? images,
  }) =>
      ChatMessage(
        id: id,
        status: status ?? this.status,
        hasBeenSentByLoggedUser: hasBeenSentByLoggedUser,
        dateTime: dateTime,
        text: text,
        images: images ?? this.images,
      );
}

extension _MessageExtension on Message {
  Message copyWithStatus(MessageStatus status) => Message(
        id: id,
        status: status,
        chatId: chatId,
        senderId: senderId,
        dateTime: dateTime,
        text: text,
      );
}
