import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/common/date_service.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
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
  }) =>
      ChatCubit(
        chatId: chatId,
        initialState: ChatState(
          status: const BlocStatusInitial(),
          loggedUserId: loggedUserId,
          messagesFromLatest: messagesFromLatest,
          messageToSend: messageToSend,
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
      final Person sender = createPerson(
        id: loggedUserId,
        name: 'sender',
        surname: 'senderski',
      );
      final Person recipient = createPerson(
        id: 'r1',
        name: 'recipient',
        surname: 'recipinsky',
      );
      final List<Message> messages = [
        createMessage(content: 'message 1', dateTime: DateTime(2023, 1, 10)),
        createMessage(content: 'message 2', dateTime: DateTime(2023, 1, 5)),
      ];
      final List<Message> updatedMessages = [
        createMessage(
          content: 'updated message 1',
          dateTime: DateTime(2023, 1, 2),
        ),
        createMessage(
          content: 'updated message 2',
          dateTime: DateTime(2023, 1, 5),
        ),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);

      blocTest(
        'should load logged user id, full names of sender and recipient and '
        'should set listener of messages and should sort messages ascending by date before emitting them',
        build: () => createCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          chatRepository.mockGetChatById(
            chat: Chat(id: chatId, user1Id: recipient.id, user2Id: sender.id),
          );
          when(
            () => personRepository.getPersonById(personId: sender.id),
          ).thenAnswer((_) => Stream.value(sender));
          when(
            () => personRepository.getPersonById(personId: recipient.id),
          ).thenAnswer((_) => Stream.value(recipient));
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
            status: const BlocStatusComplete(),
            loggedUserId: loggedUserId,
            senderFullName: '${sender.name} ${sender.surname}',
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: messages,
          ),
          ChatState(
            status: const BlocStatusComplete(),
            loggedUserId: loggedUserId,
            senderFullName: '${sender.name} ${sender.surname}',
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messagesFromLatest: updatedMessages.reversed.toList(),
          ),
        ],
        verify: (_) {
          verify(() => chatRepository.getChatById(chatId: chatId)).called(1);
          verify(
            () => personRepository.getPersonById(personId: sender.id),
          ).called(1);
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
      const ChatState(status: BlocStatusComplete(), messageToSend: 'message'),
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
    'message to send is null, '
    'should do nothing',
    build: () => createCubit(loggedUserId: loggedUserId),
    act: (cubit) => cubit.submitMessage(),
    expect: () => [],
  );

  blocTest(
    'submit message, '
    'message to send is empty string, '
    'should do nothing',
    build: () => createCubit(loggedUserId: loggedUserId, messageToSend: ''),
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
        status: BlocStatusError<ChatCubitError>(
          error: ChatCubitError.noInternetConnection,
        ),
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
    'should set messageToSend as null',
    build: () => createCubit(
      loggedUserId: loggedUserId,
      messageToSend: 'message',
    ),
    setUp: () {
      connectivityService.mockHasDeviceInternetConnection(hasConnection: true);
      dateService.mockGetNow(now: DateTime(2023, 1, 1, 12, 30));
      messageRepository.mockAddMessageToChat();
    },
    act: (cubit) => cubit.submitMessage(),
    expect: () => [
      const ChatState(
        status: BlocStatusLoading(),
        loggedUserId: loggedUserId,
        messageToSend: 'message',
      ),
      const ChatState(
        status: BlocStatusComplete(),
        loggedUserId: loggedUserId,
      ),
    ],
    verify: (_) => verify(
      () => messageRepository.addMessageToChat(
        chatId: chatId,
        senderId: loggedUserId,
        content: 'message',
        dateTime: DateTime(2023, 1, 1, 12, 30),
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
