import '../entity/chat.dart';

abstract interface class ChatRepository {
  Stream<Chat?> getChatById({required String chatId});

  Future<String?> findChatIdByUsers({
    required String user1Id,
    required String user2Id,
  });

  Future<String?> createChatForUsers({
    required String user1Id,
    required String user2Id,
  });
}
