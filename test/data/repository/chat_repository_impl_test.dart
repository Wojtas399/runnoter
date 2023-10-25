import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/model/chat.dart';
import 'package:runnoter/data/model/custom_exception.dart';
import 'package:runnoter/data/repository/chat/chat_repository_impl.dart';

import '../../creators/chat_creator.dart';
import '../../creators/chat_dto_creator.dart';
import '../../mock/firebase/mock_firebase_chat_service.dart';

void main() {
  final dbChatService = MockFirebaseChatService();
  late ChatRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseChatService>(() => dbChatService);
  });

  setUp(() => repository = ChatRepositoryImpl());

  tearDown(() {
    reset(dbChatService);
  });

  test(
    'getChatById, '
    'should set listener of db chat and should update matching chat in repo',
    () {
      const String chatId = 'c1';
      final ChatDto chatDto =
          createChatDto(id: chatId, user1Id: 'u1', user2Id: 'u2');
      final ChatDto updatedChatDto =
          createChatDto(id: chatId, user1Id: 'u2', user2Id: 'u1');
      final Chat expectedChat =
          createChat(id: chatId, user1Id: 'u1', user2Id: 'u2');
      final Chat expectedUpdatedChat =
          createChat(id: chatId, user1Id: 'u2', user2Id: 'u1');
      final List<Chat> existingChats = [
        createChat(id: 'c2'),
        createChat(id: 'c3'),
      ];
      final StreamController<ChatDto?> chatDto$ = StreamController()
        ..add(chatDto);
      dbChatService.mockGetChatById(chatDtoStream: chatDto$.stream);
      repository = ChatRepositoryImpl(initialData: existingChats);

      final Stream<Chat?> chat$ = repository.getChatById(chatId: chatId);
      chatDto$.add(updatedChatDto);

      expect(
        chat$,
        emitsInOrder(
          [expectedChat, expectedUpdatedChat],
        ),
      );
      expect(
        repository.repositoryState$,
        emitsInOrder([
          existingChats,
          [...existingChats, expectedChat],
          [...existingChats, expectedUpdatedChat],
        ]),
      );
    },
  );

  test(
    'getChatsContainingUser, '
    'should load chats from db which contain specified user id and '
    'should add them to repo, '
    'should emit all chats from repo which contain specified user id',
    () async {
      const String userId = 'u1';
      final List<Chat> existingChats = [
        createChat(id: 'c1', user1Id: 'u2', user2Id: 'u3'),
        createChat(id: 'c2', user1Id: 'u2', user2Id: userId),
        createChat(id: 'c3', user1Id: userId, user2Id: 'u3'),
        createChat(id: 'c4', user1Id: 'u3', user2Id: 'u4'),
      ];
      final List<ChatDto> loadedChatDtos = [
        createChatDto(id: 'c5', user1Id: userId, user2Id: 'u4'),
        createChatDto(id: 'c6', user1Id: 'u5', user2Id: userId),
      ];
      final List<Chat> loadedChats = [
        createChat(id: 'c5', user1Id: userId, user2Id: 'u4'),
        createChat(id: 'c6', user1Id: 'u5', user2Id: userId),
      ];
      dbChatService.mockLoadChatsContainingUser(chatDtos: loadedChatDtos);
      repository = ChatRepositoryImpl(initialData: existingChats);

      Stream<List<Chat>> chats$ =
          repository.getChatsContainingUser(userId: userId);

      expect(
        chats$,
        emits(
          [existingChats[1], existingChats[2], ...loadedChats],
        ),
      );
      expect(
        repository.repositoryState$,
        emitsInOrder([
          existingChats,
          [...existingChats, ...loadedChats],
        ]),
      );
    },
  );

  test(
    'findChatIdByUsers, '
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
    'findChatIdByUsers, '
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
      dbChatService.mockLoadChatByUsers(chatDto: loadedChatDto);
      repository = ChatRepositoryImpl(initialData: existingChats);

      final String? chatId = await repository.findChatIdByUsers(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, expectedChatId);
      expect(
        repository.repositoryState$,
        emitsInOrder([
          [...existingChats, loadedChat]
        ]),
      );
      verify(
        () => dbChatService.loadChatByUsers(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );

  test(
    'createChatForUsers, '
    'should add new chat to db and to repo and should return its id',
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
      dbChatService.mockAddNewChat(addedChatDto: addedChatDto);

      final String? chatId = await repository.createChatForUsers(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      expect(chatId, expectedChatId);
      expect(
        repository.repositoryState$,
        emitsInOrder([
          [addedChat],
        ]),
      );
      verify(
        () => dbChatService.addNewChat(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );

  test(
    'createChatForUsers, '
    'db document exception with documentAlreadyExists code, '
    'should throw entity exception with entityAlreadyExists code',
    () async {
      const CustomException expectedException = EntityException(
        code: EntityExceptionCode.entityAlreadyExists,
      );
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      dbChatService.mockAddNewChat(
        throwable: const FirebaseDocumentException(
          code: FirebaseDocumentExceptionCode.documentAlreadyExists,
        ),
      );

      Object? exception;
      try {
        await repository.createChatForUsers(user1Id: user1Id, user2Id: user2Id);
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => dbChatService.addNewChat(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );

  test(
    'updateChat, '
    'should update chat in db and in repo',
    () async {
      const String chatId = 'c3';
      final DateTime user1LastTypingDateTime = DateTime(2023, 1, 10);
      final DateTime user2LastTypingDateTime = DateTime(2023, 1, 05);
      final List<Chat> existingChats = [
        createChat(id: 'c1'),
        createChat(id: 'c2'),
        createChat(id: chatId),
      ];
      final ChatDto updatedChatDto = createChatDto(
        id: chatId,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );
      final Chat updatedChat = createChat(
        id: chatId,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );
      dbChatService.mockUpdateChat(updatedChatDto: updatedChatDto);
      repository = ChatRepositoryImpl(initialData: existingChats);

      await repository.updateChat(
        chatId: chatId,
        user1LastTypingDateTime: user1LastTypingDateTime,
        user2LastTypingDateTime: user2LastTypingDateTime,
      );

      expect(
        repository.repositoryState$,
        emits([existingChats[0], existingChats[1], updatedChat]),
      );
      verify(
        () => dbChatService.updateChat(
          chatId: chatId,
          user1LastTypingDateTime: user1LastTypingDateTime,
          user2LastTypingDateTime: user2LastTypingDateTime,
        ),
      ).called(1);
    },
  );

  test(
    'delete chat, '
    'should delete chat from db and from repo',
    () async {
      const String chatId = 'c2';
      final List<Chat> existingChats = [
        createChat(id: 'c1'),
        createChat(id: 'c2'),
        createChat(id: 'c3'),
      ];
      dbChatService.mockDeleteChat();
      repository = ChatRepositoryImpl(initialData: existingChats);

      await repository.deleteChat(chatId: chatId);

      expect(
        repository.repositoryState$,
        emits([existingChats.first, existingChats.last]),
      );
      verify(() => dbChatService.deleteChat(chatId: chatId)).called(1);
    },
  );
}
