import '../entity/chat.dart';

abstract interface class ChatRepository {
  Stream<Chat?> getChatById({required String chatId});

  Future<bool> doUsersHaveChat({
    required String user1Id,
    required String user2Id,
  });

  Future<void> createChatForUsers({
    required String user1Id,
    required String user2Id,
  });
}
