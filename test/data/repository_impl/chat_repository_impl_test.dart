import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/chat_repository_impl.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/entity/chat.dart';

import '../../creators/chat_creator.dart';
import '../../creators/chat_dto_creator.dart';
import '../../mock/firebase/mock_firebase_chat_service.dart';

void main() {
  final firebaseChatService = MockFirebaseChatService();
  late ChatRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseChatService>(() => firebaseChatService);
  });

  setUp(() => repository = ChatRepositoryImpl());

  tearDown(() {
    reset(firebaseChatService);
  });

  test(
    'get chat by id, '
    'chat exist in repo, '
    'should emit chat from repo',
    () {
      final Chat expectedChat = createChat(id: 'c1');
      final List<Chat> existingChats = [
        expectedChat,
        createChat(id: 'c2'),
        createChat(id: 'c3'),
      ];
      repository = ChatRepositoryImpl(initialData: existingChats);

      final Stream<Chat?> chat$ =
          repository.getChatById(chatId: expectedChat.id);

      expect(
        chat$,
        emitsInOrder([
          expectedChat,
        ]),
      );
    },
  );

  test(
    'get chat by id, '
    'chat does not exist in repo, '
    'should load chat from db, add it to repo and emit it',
    () {
      const String chatId = 'c1';
      final Chat expectedChat = createChat(id: chatId);
      final List<Chat> existingChats = [
        createChat(id: 'c2'),
        createChat(id: 'c3'),
      ];
      final ChatDto loadedChatDto = createChatDto(id: chatId);
      firebaseChatService.mockLoadChatById(chatDto: loadedChatDto);
      repository = ChatRepositoryImpl(initialData: existingChats);

      final Stream<Chat?> chat$ = repository.getChatById(chatId: chatId);

      expect(
        chat$,
        emitsInOrder([
          expectedChat,
        ]),
      );
      expect(
        repository.dataStream$,
        emitsInOrder([
          existingChats,
          [...existingChats, expectedChat]
        ]),
      );
    },
  );

  test(
    'find chat id by users, '
    'chat exist in repo, '
    'should emit id of chat existing in repo',
    () async {
      const String expectedChatId = 'c1';
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      final List<Chat> existingChats = [
        createChat(id: expectedChatId, user1Id: user2Id, user2Id: user1Id),
        createChat(id: 'c2', user1Id: user1Id, user2Id: 'u3'),
        createChat(id: 'c3', user1Id: 'u4', user2Id: user2Id),
      ];
      repository = ChatRepositoryImpl(initialData: existingChats);

      final String? chatId = await repository.findChatIdByUsers(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, expectedChatId);
    },
  );

  test(
    'find chat id by users, '
    'chat does not exist in repo, '
    'should load chat from db, add it to repo and return it',
    () async {
      const String expectedChatId = 'c1';
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      final List<Chat> existingChats = [
        createChat(id: 'c2', user1Id: user1Id, user2Id: 'u3'),
        createChat(id: 'c3', user1Id: 'u4', user2Id: user2Id),
      ];
      final ChatDto loadedChatDto = createChatDto(
        id: expectedChatId,
        user1Id: user2Id,
        user2Id: user1Id,
      );
      final Chat loadedChat = createChat(
        id: expectedChatId,
        user1Id: user2Id,
        user2Id: user1Id,
      );
      firebaseChatService.mockLoadChatByUsers(chatDto: loadedChatDto);
      repository = ChatRepositoryImpl(initialData: existingChats);

      final String? chatId = await repository.findChatIdByUsers(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, expectedChatId);
      expect(
        repository.dataStream$,
        emitsInOrder([
          [...existingChats, loadedChat]
        ]),
      );
      verify(
        () => firebaseChatService.loadChatByUsers(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );

  test(
    'create chat for users, '
    "should call firebase chat service's method to add new chat, should add this new chat to repo and return its id",
    () async {
      const String expectedChatId = 'c1';
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      final ChatDto addedChatDto = createChatDto(
        id: expectedChatId,
        user1Id: user1Id,
        user2Id: user2Id,
      );
      final Chat addedChat = createChat(
        id: expectedChatId,
        user1Id: user1Id,
        user2Id: user2Id,
      );
      firebaseChatService.mockAddNewChat(addedChatDto: addedChatDto);

      final String? chatId = await repository.createChatForUsers(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, expectedChatId);
      expect(
        repository.dataStream$,
        emitsInOrder([
          [addedChat],
        ]),
      );
      verify(
        () => firebaseChatService.addNewChat(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );

  test(
    'create chat for users, '
    'firebase chat exception with chatAlreadyExists code, '
    'should throw chat exception with chatAlreadyExists code',
    () async {
      const ChatException expectedChatException = ChatException(
        code: ChatExceptionCode.chatAlreadyExists,
      );
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      firebaseChatService.mockAddNewChat(
        throwable: const FirebaseChatException(
          code: FirebaseChatExceptionCode.chatAlreadyExists,
        ),
      );

      Object? exception;
      try {
        await repository.createChatForUsers(user1Id: user1Id, user2Id: user2Id);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedChatException);
      verify(
        () => firebaseChatService.addNewChat(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );
}
