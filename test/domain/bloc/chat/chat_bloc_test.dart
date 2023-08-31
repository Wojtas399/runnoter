import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/chat/chat_bloc.dart';
import 'package:runnoter/domain/entity/chat.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/entity/person.dart';
import 'package:runnoter/domain/repository/chat_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';

import '../../../creators/message_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_chat_repository.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';

void main() {
  final authService = MockAuthService();
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  final personRepository = MockPersonRepository();
  const String chatId = 'c1';
  const String loggedUserId = 'u1';

  ChatBloc createBloc() => ChatBloc(chatId: chatId);

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(authService);
    reset(chatRepository);
    reset(messageRepository);
    reset(personRepository);
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
        createMessage(content: 'message 1'),
        createMessage(content: 'message 2'),
      ];
      final List<Message> updatedMessages = [
        createMessage(content: 'updated message 1'),
        createMessage(content: 'updated message 2'),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);

      blocTest(
        'should load full names of sender and recipient and '
        'should set listener of messages',
        build: () => createBloc(),
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
        act: (bloc) {
          bloc.add(const ChatEventInitialize());
          messages$.add(updatedMessages);
        },
        expect: () => [
          ChatState(
            status: const BlocStatusComplete(),
            senderFullName: '${sender.name} ${sender.surname}',
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messages: messages,
          ),
          ChatState(
            status: const BlocStatusComplete(),
            senderFullName: '${sender.name} ${sender.surname}',
            recipientFullName: '${recipient.name} ${recipient.surname}',
            messages: updatedMessages,
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
    build: () => createBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const ChatEventInitialize()),
    expect: () => [],
  );
}
