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

import '../../../creators/message_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_chat_repository.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';

void main() {
  final chatRepository = MockChatRepository();
  final messageRepository = MockMessageRepository();
  final personRepository = MockPersonRepository();
  const String senderId = 's1';
  const String recipientId = 'r1';

  ChatBloc createBloc() => ChatBloc(
        senderId: senderId,
        recipientId: recipientId,
      );

  setUpAll(() {
    GetIt.I.registerSingleton<ChatRepository>(chatRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
  });

  tearDown(() {
    reset(chatRepository);
    reset(messageRepository);
    reset(personRepository);
  });

  group(
    'initialize',
    () {
      final Person sender = createPerson(name: 'sender', surname: 'senderski');
      final Person recipient = createPerson(
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
          when(
            () => personRepository.getPersonById(personId: senderId),
          ).thenAnswer((_) => Stream.value(sender));
          when(
            () => personRepository.getPersonById(personId: recipientId),
          ).thenAnswer((_) => Stream.value(recipient));
          chatRepository.mockGetChatByUsers(
            chat: const Chat(id: 'c1', user1Id: senderId, user2Id: recipientId),
          );
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
          verify(
            () => personRepository.getPersonById(personId: senderId),
          ).called(1);
          verify(
            () => personRepository.getPersonById(personId: recipientId),
          ).called(1);
          verify(
            () => chatRepository.getChatByUsers(
              user1Id: senderId,
              user2Id: recipientId,
            ),
          ).called(1);
          verify(
            () => messageRepository.getMessagesForChat(chatId: 'c1'),
          ).called(1);
        },
      );
    },
  );
}
