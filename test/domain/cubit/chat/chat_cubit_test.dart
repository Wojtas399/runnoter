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
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/connectivity_service.dart';

import '../../../creators/message_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/common/mock_date_service.dart';
import '../../../mock/domain/repository/mock_chat_repository.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_connectivity_service.dart';

void main() {
  final authService = MockAuthService();
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  final personRepository = MockPersonRepository();
  final dateService = MockDateService();
  final connectivityService = MockConnectivityService();
  const String chatId = 'c1';
  const String loggedUserId = 'u1';

  ChatCubit createCubit({
    String? loggedUserId,
    List<Message>? messagesFromLatest,
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
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<DateService>(() => dateService);
    GetIt.I.registerFactory<ConnectivityService>(() => connectivityService);
  });

  tearDown(() {
    reset(authService);
    reset(chatRepository);
    reset(messageRepository);
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
        createMessage(text: 'message 1', dateTime: DateTime(2023, 1, 10)),
        createMessage(text: 'message 2', dateTime: DateTime(2023, 1, 5)),
      ];
      final List<Message> updatedMessages = [
        createMessage(
          text: 'updated message 1',
          dateTime: DateTime(2023, 1, 2),
        ),
        createMessage(
          text: 'updated message 2',
          dateTime: DateTime(2023, 1, 5),
        ),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);

      blocTest(
        'should load logged user id and recipient, '
        'should set listener of messages and should sort messages ascending by date before emitting them',
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
        },
        act: (cubit) {
          cubit.initialize();
          messages$.add(updatedMessages);
        },
        expect: () => [
          ChatState(
            status: const CubitStatusComplete(),
            loggedUserId: loggedUserId,
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: messages,
          ),
          ChatState(
            status: const CubitStatusComplete(),
            loggedUserId: loggedUserId,
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: updatedMessages.reversed.toList(),
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
    "should call message repository's method to add new message with current dateTime and "
    'should set messageToSend as null and imagesToSend as empty array',
    build: () => createCubit(
      loggedUserId: loggedUserId,
      messageToSend: 'message',
      imagesToSend: [Uint8List(1), Uint8List(2)],
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      messageRepository.mockAddMessageToChat();
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
        status: CubitStatusComplete(),
        loggedUserId: loggedUserId,
        messageToSend: null,
        imagesToSend: [],
      ),
    ],
    verify: (_) => verify(
      () => messageRepository.addMessageToChat(
        chatId: chatId,
        senderId: loggedUserId,
        dateTime: DateTime(2023, 1, 1, 12, 30),
        text: 'message',
        images: [
          MessageImage(order: 1, bytes: Uint8List(1)),
          MessageImage(order: 2, bytes: Uint8List(2)),
        ],
      ),
    ).called(1),
  );

  blocTest(
    'load older messages, '
    "should call message repository's method to load older messages with id of the oldest message in state",
    build: () => createCubit(
      messagesFromLatest: [
        createMessage(id: 'm1', dateTime: DateTime(2023, 1, 2)),
        createMessage(id: 'm2', dateTime: DateTime(2023, 1, 5)),
        createMessage(id: 'm3', dateTime: DateTime(2023, 1, 10)),
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
