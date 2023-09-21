import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';

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
  Stream<Chat?> getChatById({required String chatId}) {
    return dataStream$
        .map(
          (List<Chat>? chats) => chats?.firstWhereOrNull(
            (Chat chat) => chat.id == chatId,
          ),
        )
        .asyncMap(
          (Chat? chat) async => chat ?? await _loadChatByIdFromDb(chatId),
        );
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
    } on FirebaseException catch (exception) {
      throw mapExceptionFromFirebase(exception);
    }
  }

  Future<Chat?> _loadChatByIdFromDb(String chatId) async {
    final chatDto = await _dbChatService.loadChatById(chatId: chatId);
    if (chatDto == null) return null;
    final Chat chat = mapChatFromDto(chatDto);
    addEntity(chat);
    return chat;
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
}
