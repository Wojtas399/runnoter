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
    String? loggedUserId,
    List<ChatMessage>? messagesFromLatest,
    String? messageToSend,
    List<Uint8List> imagesToSend = const [],
  }) =>
      ChatCubit(
        chatId: chatId,
        initialState: ChatState(
          status: const CubitStatusInitial(),
          loggedUserId: loggedUserId,
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
    'initialize',
    () {
      final Person recipient = createPerson(
        id: 'r1',
        name: 'recipient',
        surname: 'recipinsky',
      );
      final List<Message> messages = [
        createMessage(
          id: 'm1',
          text: 'message 1',
          senderId: 'u1',
          dateTime: DateTime(2023, 1, 10),
        ),
        createMessage(
          id: 'm2',
          text: 'message 2',
          senderId: 'u2',
          dateTime: DateTime(2023, 1, 5),
        ),
      ];
      final List<Message> updatedMessages = [
        createMessage(
          id: 'm1',
          text: 'updated message 1',
          senderId: 'u1',
          dateTime: DateTime(2023, 1, 2),
        ),
        createMessage(
          id: 'm2',
          senderId: 'u2',
          text: 'updated message 2',
          dateTime: DateTime(2023, 1, 5),
        ),
      ];
      final List<MessageImage> m1MessageImages = [
        MessageImage(id: 'i2', messageId: 'm2', order: 2, bytes: Uint8List(2)),
        MessageImage(id: 'i1', messageId: 'm1', order: 1, bytes: Uint8List(1)),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);
      final StreamController<List<MessageImage>> m1MessageImages$ =
          BehaviorSubject.seeded(m1MessageImages);
      final StreamController<List<MessageImage>> m2MessageImages$ =
          BehaviorSubject.seeded(const []);

      blocTest(
        'should load logged user id and recipient, '
        'should set listener of messages with images and '
        'should sort messages descending by date and '
        'should sort images ascending by order',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          chatRepository.mockGetChatById(
            chat: Chat(
              id: chatId,
              user1Id: recipient.id,
              user2Id: loggedUserId,
            ),
          );
          personRepository.mockGetPersonById(person: recipient);
          messageRepository.mockGetMessagesForChat(
            messagesStream: messages$.stream,
          );
          when(
            () => messageImageRepository.getImagesByMessageId(messageId: 'm1'),
          ).thenAnswer((_) => m1MessageImages$.stream);
          when(
            () => messageImageRepository.getImagesByMessageId(messageId: 'm2'),
          ).thenAnswer((_) => m2MessageImages$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          messages$.add(updatedMessages);
          await cubit.stream.first;
          m1MessageImages$.add([]);
        },
        expect: () => [
          ChatState(
            status: const CubitStatusComplete(),
            loggedUserId: loggedUserId,
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: [
              ChatMessage(
                id: 'm1',
                senderId: 'u1',
                sendDateTime: DateTime(2023, 1, 10),
                text: 'message 1',
                images: [
                  MessageImage(
                    id: 'i1',
                    messageId: 'm1',
                    order: 1,
                    bytes: Uint8List(1),
                  ),
                  MessageImage(
                    id: 'i2',
                    messageId: 'm2',
                    order: 2,
                    bytes: Uint8List(2),
                  ),
                ],
              ),
              ChatMessage(
                id: 'm2',
                senderId: 'u2',
                sendDateTime: DateTime(2023, 1, 5),
                text: 'message 2',
                images: const [],
              ),
            ],
          ),
          ChatState(
            status: const CubitStatusComplete(),
            loggedUserId: loggedUserId,
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: [
              ChatMessage(
                id: 'm2',
                senderId: 'u2',
                sendDateTime: DateTime(2023, 1, 5),
                text: 'updated message 2',
                images: const [],
              ),
              ChatMessage(
                id: 'm1',
                senderId: 'u1',
                sendDateTime: DateTime(2023, 1, 2),
                text: 'updated message 1',
                images: [
                  MessageImage(
                    id: 'i1',
                    messageId: 'm1',
                    order: 1,
                    bytes: Uint8List(1),
                  ),
                  MessageImage(
                    id: 'i2',
                    messageId: 'm2',
                    order: 2,
                    bytes: Uint8List(2),
                  ),
                ],
              ),
            ],
          ),
          ChatState(
            status: const CubitStatusComplete(),
            loggedUserId: loggedUserId,
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: [
              ChatMessage(
                id: 'm2',
                senderId: 'u2',
                sendDateTime: DateTime(2023, 1, 5),
                text: 'updated message 2',
                images: const [],
              ),
              ChatMessage(
                id: 'm1',
                senderId: 'u1',
                sendDateTime: DateTime(2023, 1, 2),
                text: 'updated message 1',
                images: const [],
              ),
            ],
          ),
        ],
        verify: (_) {
          verify(() => chatRepository.getChatById(chatId: chatId)).called(1);
          verify(
            () => personRepository.getPersonById(personId: recipient.id),
          ).called(1);
          verify(
            () => messageRepository.getMessagesForChat(chatId: 'c1'),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => createCubit(messageToSend: 'message to send'),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
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
    'logged user does not exist, '
    'should do nothing',
    build: () => createCubit(messageToSend: 'message'),
    act: (cubit) => cubit.submitMessage(),
    expect: () => [],
  );

  blocTest(
    'submit message, '
    'no internet connection, '
    'should emit noInternetConnection error',
    build: () => createCubit(
      loggedUserId: loggedUserId,
      messageToSend: 'message',
    ),
    setUp: () => connectivityService.mockHasDeviceInternetConnection(
      hasConnection: false,
    ),
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(
        status: CubitStatusNoInternetConnection(),
        loggedUserId: loggedUserId,
        messageToSend: 'message',
      ),
    ],
    verify: (_) => verify(
      () => connectivityService.hasDeviceInternetConnection(),
    ).called(1),
  );

  blocTest(
    'submit message, '
    'there are no images to send, '
    'should call message repository method to add new message with current dateTime and '
    'should set messageToSend as null',
    build: () => createCubit(
      loggedUserId: loggedUserId,
      messageToSend: 'message',
      imagesToSend: [],
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      messageRepository.mockAddMessage(addedMessageId: 'm1');
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(
        status: CubitStatusLoading(),
        loggedUserId: loggedUserId,
        messageToSend: 'message',
        imagesToSend: [],
      ),
      const ChatState(
        status: CubitStatusLoading(),
        loggedUserId: loggedUserId,
        messageToSend: null,
        imagesToSend: [],
      ),
    ],
    verify: (_) => verify(
      () => messageRepository.addMessage(
        chatId: chatId,
        senderId: loggedUserId,
        dateTime: DateTime(2023, 1, 1, 12, 30),
        text: 'message',
      ),
    ).called(1),
  );

  blocTest(
    'submit message, '
    'should call message repository method to add new message with current dateTime and '
    'should call message image repository to add images to message and '
    'should set messageToSend as null and imagesToSend as empty array',
    build: () => createCubit(
      loggedUserId: loggedUserId,
      messageToSend: 'message',
      imagesToSend: [Uint8List(1), Uint8List(2)],
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      messageRepository.mockAddMessage(addedMessageId: 'm1');
      messageImageRepository.mockAddImagesInOrderToMessage();
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      ChatState(
        status: const CubitStatusLoading(),
        loggedUserId: loggedUserId,
        messageToSend: 'message',
        imagesToSend: [Uint8List(1), Uint8List(2)],
      ),
      const ChatState(
        status: CubitStatusLoading(),
        loggedUserId: loggedUserId,
        messageToSend: null,
        imagesToSend: [],
      ),
    ],
    verify: (_) {
      verify(
        () => messageRepository.addMessage(
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
    "should call message repository's method to load older messages with id of the oldest message in state",
    build: () => createCubit(
      messagesFromLatest: [
        ChatMessage(
          id: 'm1',
          senderId: 'u1',
          sendDateTime: DateTime(2023, 1, 2),
        ),
        ChatMessage(
          id: 'm2',
          senderId: 'u2',
          sendDateTime: DateTime(2023, 1, 5),
        ),
        ChatMessage(
          id: 'm3',
          senderId: 'u1',
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
