import '../entity/chat.dart';

abstract interface class ChatRepository {
  Stream<Chat?> getChatByUsers({
    required String user1Id,
    required String user2Id,
  });

  Future<void> createChatForUsers({
    required String user1Id,
    required String user2Id,
  });
}
