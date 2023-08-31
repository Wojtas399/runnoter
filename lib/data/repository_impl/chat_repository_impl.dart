import '../../domain/entity/chat.dart';
import '../../domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
  Stream<Chat?> getChatById({required String chatId}) {
    // TODO: implement getChatByUsers
    throw UnimplementedError();
  }

  @override
  Future<String?> findChatIdByUsers({
    required String user1Id,
    required String user2Id,
  }) {
    // TODO: implement doUsersHaveChat
    throw UnimplementedError();
  }

  @override
  Future<String?> createChatForUsers({
    required String user1Id,
    required String user2Id,
  }) {
    // TODO: implement createChatForUsers
    throw UnimplementedError();
  }
}
