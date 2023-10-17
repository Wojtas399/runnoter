import '../../model/chat.dart';

abstract interface class ChatRepository {
  Stream<Chat?> getChatById({required String chatId});

  Stream<List<Chat>> getChatsContainingUser({required String userId});

  Future<String?> findChatIdByUsers({
    required String user1Id,
    required String user2Id,
  });

  Future<String?> createChatForUsers({
    required String user1Id,
    required String user2Id,
  });

  Future<void> updateChat({
    required String chatId,
    DateTime? user1LastTypingDateTime,
    DateTime? user2LastTypingDateTime,
  });

  Future<void> deleteChat({required String chatId});
}
