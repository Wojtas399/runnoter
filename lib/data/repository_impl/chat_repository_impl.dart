import 'dart:async';

import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/chat.dart';
import '../../domain/repository/chat_repository.dart';
import '../mapper/chat_mapper.dart';
import '../mapper/custom_exception_mapper.dart';

class ChatRepositoryImpl extends StateRepository<Chat>
    implements ChatRepository {
  final FirebaseChatService _dbChatService;

  ChatRepositoryImpl({super.initialData})
      : _dbChatService = getIt<FirebaseChatService>();

  @override
  Stream<Chat?> getChatById({required String chatId}) => _dbChatService
      .getChatById(chatId: chatId)
      .map(
        (chatDto) => chatDto != null ? mapChatFromDto(chatDto) : null,
      )
      .distinct()
      .doOnData(_manageChatChanges);

  @override
  Stream<List<Chat>> getChatsContainingUser({required String userId}) async* {
    await _loadChatsContainingUserFromDb(userId);
    await for (final chats in dataStream$) {
      yield [
        ...?chats?.where(
          (chat) => chat.user1Id == userId || chat.user2Id == userId,
        ),
      ];
    }
  }

  @override
  Future<String?> findChatIdByUsers({
    required String user1Id,
    required String user2Id,
  }) async {
    final List<Chat>? existingChats = await dataStream$.first;
    Chat? foundChat = existingChats?.firstWhereOrNull(
      (Chat chat) {
        final List<String> userIdsToMatch = [user1Id, user2Id];
        return userIdsToMatch.contains(chat.user1Id) &&
            userIdsToMatch.contains(chat.user2Id);
      },
    );
    foundChat ??= await _loadChatByUsersFromDb(user1Id, user2Id);
    return foundChat?.id;
  }

  @override
  Future<String?> createChatForUsers({
    required String user1Id,
    required String user2Id,
  }) async {
    try {
      final chatDto = await _dbChatService.addNewChat(
        user1Id: user1Id,
        user2Id: user2Id,
      );
      if (chatDto == null) return null;
      final Chat chat = mapChatFromDto(chatDto);
      addEntity(chat);
      return chat.id;
    } on CustomFirebaseException catch (exception) {
      throw mapExceptionFromDb(exception);
    }
  }

  @override
  Future<void> updateChat({
    required String chatId,
    DateTime? user1LastTypingDateTime,
    DateTime? user2LastTypingDateTime,
  }) async {
    final ChatDto? updatedChatDto = await _dbChatService.updateChat(
      chatId: chatId,
      user1LastTypingDateTime: user1LastTypingDateTime,
      user2LastTypingDateTime: user2LastTypingDateTime,
    );
    if (updatedChatDto != null) {
      final Chat chat = mapChatFromDto(updatedChatDto);
      updateEntity(chat);
    }
  }

  void _manageChatChanges(Chat? chat) {
    if (chat == null) return;
    if (doesEntityNotExistInState(chat.id)) {
      addEntity(chat);
    } else {
      updateEntity(chat);
    }
  }

  Future<Chat?> _loadChatByUsersFromDb(String user1Id, String user2Id) async {
    final chatDto = await _dbChatService.loadChatByUsers(
      user1Id: user1Id,
      user2Id: user2Id,
    );
    if (chatDto == null) return null;
    final Chat chat = mapChatFromDto(chatDto);
    addEntity(chat);
    return chat;
  }

  Future<void> _loadChatsContainingUserFromDb(String userId) async {
    final List<ChatDto> chatDtos =
        await _dbChatService.loadChatsContainingUser(userId: userId);
    if (chatDtos.isNotEmpty) {
      final List<Chat> chats = chatDtos.map(mapChatFromDto).toList();
      addOrUpdateEntities(chats);
    }
  }
}
