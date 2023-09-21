import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/cubit/chat/chat_cubit.dart';
import 'package:runnoter/domain/entity/chat.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/entity/message_image.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';
import 'package:runnoter/domain/repository/message_image_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/connectivity_service.dart';
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
import '../../../mock/domain/service/mock_connectivity_service.dart';

void main() {
  final authService = MockAuthService();
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  final messageImageRepository = MockMessageImageRepository();
  final personRepository = MockPersonRepository();
  final dateService = MockDateService();
  final connectivityService = MockConnectivityService();
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
          status: const CubitStatusInitial(),
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
    GetIt.I.registerFactory<ConnectivityService>(() => connectivityService);
  });

  tearDown(() {
    reset(authService);
    reset(chatRepository);
    reset(messageRepository);
    reset(messageImageRepository);
    reset(personRepository);
    reset(dateService);
    reset(connectivityService);
  });

  group(
    'initialize chat listener',
    () {
      final Chat chat = createChat(
        id: 'c1',
        user1Id: 'u2',
        user2Id: loggedUserId,
      );
      final Chat updatedChat = createChat(
        id: 'c1',
        user1Id: 'u2',
        user2Id: loggedUserId,
        isUser1Typing: true,
        isUser2Typing: false,
      );
      final Person recipient = createPerson(
        id: 'u2',
        name: 'name',
        surname: 'surname',
      );
      final StreamController<Chat> chat$ = StreamController()..add(chat);

      blocTest(
        'should set listener of chat and '
        'should load recipient full name and '
        'should check if recipient is typing',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          chatRepository.mockGetChatById(chatStream: chat$.stream);
          personRepository.mockGetPersonById(person: recipient);
        },
        act: (cubit) {
          cubit.initializeChatListener();
          chat$.add(updatedChat);
        },
        expect: () => [
          const ChatState(
            status: CubitStatusComplete(),
            recipientFullName: 'name surname',
            isRecipientTyping: false,
          ),
          const ChatState(
            status: CubitStatusComplete(),
            recipientFullName: 'name surname',
            isRecipientTyping: true,
          ),
        ],
        verify: (_) => verify(
          () => chatRepository.getChatById(chatId: chatId),
        ).called(1),
      );
    },
  );

  group(
    'initialize messages listener',
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
          sendDateTime: DateTime(2023, 1, 10),
          text: 'message 1',
          images: m1MessageImages.reversed.toList(),
        ),
        ChatMessage(
          id: 'm2',
          status: MessageStatus.sent,
          hasBeenSentByLoggedUser: false,
          sendDateTime: DateTime(2023, 1, 5, 10, 30),
          text: 'message 2',
          images: const [],
        ),
        ChatMessage(
          id: 'm3',
          status: MessageStatus.sent,
          hasBeenSentByLoggedUser: false,
          sendDateTime: DateTime(2023, 1, 5, 9, 30),
          text: 'message 3',
          images: const [],
        ),
        ChatMessage(
          id: 'm4',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: false,
          sendDateTime: DateTime(2023, 1, 5, 9),
          text: 'message 4',
          images: const [],
        ),
        ChatMessage(
          id: 'm5',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          sendDateTime: DateTime(2023, 1, 5, 8),
          text: 'message 5',
          images: const [],
        ),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);
      final StreamController<List<MessageImage>> m1MessageImages$ =
          BehaviorSubject.seeded(m1MessageImages);

      blocTest(
        'should set listener of messages with images, '
        'should call message repository method to mark messages sent by recipient as read, '
        'should sort messages descending by date and '
        'should sort images ascending by order',
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
        },
        expect: () => [
          ChatState(
            status: const CubitStatusComplete(),
            messagesFromLatest: expectedMessages,
          ),
          ChatState(
            status: const CubitStatusComplete(),
            messagesFromLatest: [
              expectedMessages.first,
              expectedMessages[1].copyWith(status: MessageStatus.read),
              expectedMessages[2].copyWith(status: MessageStatus.read),
              expectedMessages[3],
              expectedMessages[4],
            ],
          ),
          ChatState(
            status: const CubitStatusComplete(),
            messagesFromLatest: [
              expectedMessages.first.copyWith(images: []),
              expectedMessages[1].copyWith(status: MessageStatus.read),
              expectedMessages[2].copyWith(status: MessageStatus.read),
              expectedMessages[3],
              expectedMessages[4],
            ],
          ),
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
    'message changed, '
    'should update message to send in state',
    build: () => createCubit(),
    act: (cubit) => cubit.messageChanged('message'),
    expect: () => [
      const ChatState(status: CubitStatusComplete(), messageToSend: 'message'),
    ],
  );

  blocTest(
    'add images to send, '
    'should add new images to list',
    build: () => createCubit(
      imagesToSend: [Uint8List(1)],
    ),
    act: (cubit) => cubit.addImagesToSend([Uint8List(2), Uint8List(3)]),
    expect: () => [
      ChatState(
        status: const CubitStatusComplete(),
        imagesToSend: [Uint8List(1), Uint8List(2), Uint8List(3)],
      ),
    ],
  );

  blocTest(
    'delete image to send, '
    'index does not match to list indexes, '
    'should do nothing',
    build: () => createCubit(
      imagesToSend: [Uint8List(1), Uint8List(2), Uint8List(3)],
    ),
    act: (cubit) => cubit.deleteImageToSend(3),
    expect: () => [],
  );

  blocTest(
    'delete image to send, '
    'should delete image from list at given index',
    build: () => createCubit(
      imagesToSend: [Uint8List(1), Uint8List(2), Uint8List(3)],
    ),
    act: (cubit) => cubit.deleteImageToSend(1),
    expect: () => [
      ChatState(
        status: const CubitStatusComplete(),
        imagesToSend: [Uint8List(1), Uint8List(3)],
      ),
    ],
  );

  blocTest(
    'submit message, '
    'no internet connection, '
    'should emit noInternetConnection error',
    build: () => createCubit(messageToSend: 'message'),
    setUp: () => connectivityService.mockHasDeviceInternetConnection(
      hasConnection: false,
    ),
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(
        status: CubitStatusNoInternetConnection(),
        messageToSend: 'message',
      ),
    ],
    verify: (_) => verify(
      () => connectivityService.hasDeviceInternetConnection(),
    ).called(1),
  );

  blocTest(
    'submit message, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => createCubit(messageToSend: 'message'),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      authService.mockGetLoggedUserId();
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(
        status: CubitStatusNoLoggedUser(),
        messageToSend: 'message',
      ),
    ],
  );

  blocTest(
    'submit message, '
    'there are no images to send, '
    'should call message repository method to add new message with current dateTime and sent status and '
    'should set messageToSend as null',
    build: () => createCubit(
      messageToSend: 'message',
      imagesToSend: [],
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      authService.mockGetLoggedUserId(userId: loggedUserId);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      messageRepository.mockAddMessage(addedMessageId: 'm1');
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(
        status: CubitStatusLoading(),
        messageToSend: 'message',
        imagesToSend: [],
      ),
      const ChatState(
        status: CubitStatusLoading(),
        messageToSend: null,
        imagesToSend: [],
      ),
    ],
    verify: (_) => verify(
      () => messageRepository.addMessage(
        status: MessageStatus.sent,
        chatId: chatId,
        senderId: loggedUserId,
        dateTime: DateTime(2023, 1, 1, 12, 30),
        text: 'message',
      ),
    ).called(1),
  );

  blocTest(
    'submit message, '
    'should call message repository method to add new message with current dateTime and sent status and '
    'should call message image repository to add images to message and '
    'should set messageToSend as null and imagesToSend as empty array',
    build: () => createCubit(
      messageToSend: 'message',
      imagesToSend: [Uint8List(1), Uint8List(2)],
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      authService.mockGetLoggedUserId(userId: loggedUserId);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      messageRepository.mockAddMessage(addedMessageId: 'm1');
      messageImageRepository.mockAddImagesInOrderToMessage();
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      ChatState(
        status: const CubitStatusLoading(),
        messageToSend: 'message',
        imagesToSend: [Uint8List(1), Uint8List(2)],
      ),
      const ChatState(
        status: CubitStatusLoading(),
        messageToSend: null,
        imagesToSend: [],
      ),
    ],
    verify: (_) {
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
    'load older messages, '
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
    'load older messages, '
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
    'load older messages, '
    'should call message repository method to load older messages with id of the oldest message in state',
    build: () => createCubit(
      messagesFromLatest: [
        ChatMessage(
          id: 'm1',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          sendDateTime: DateTime(2023, 1, 2),
        ),
        ChatMessage(
          id: 'm2',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: false,
          sendDateTime: DateTime(2023, 1, 5),
        ),
        ChatMessage(
          id: 'm3',
          status: MessageStatus.read,
          hasBeenSentByLoggedUser: true,
          sendDateTime: DateTime(2023, 1, 10),
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
        sendDateTime: sendDateTime,
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
