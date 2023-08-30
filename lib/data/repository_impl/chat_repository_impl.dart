import '../../domain/entity/chat.dart';
import '../../domain/repository/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  @override
  Stream<Chat?> getChatByUsers({
    required String user1Id,
    required String user2Id,
  }) {
    // TODO: implement getChatByUsers
    throw UnimplementedError();
  }

  @override
  Future<void> createChatForUsers({
    required String user1Id,
    required String user2Id,
  }) {
    // TODO: implement createChatForUsers
    throw UnimplementedError();
  }
}
