import '../../data/repository/chat/chat_repository.dart';
import '../../dependency_injection.dart';

class LoadChatIdUseCase {
  final ChatRepository _chatRepository;

  LoadChatIdUseCase() : _chatRepository = getIt<ChatRepository>();

  Future<String?> execute({
    required String user1Id,
    required String user2Id,
  }) async {
    final String? existingChatId = await _chatRepository.findChatIdByUsers(
      user1Id: user1Id,
      user2Id: user2Id,
    );
    if (existingChatId != null) return existingChatId;
    return await _chatRepository.createChatForUsers(
      user1Id: user1Id,
      user2Id: user2Id,
    );
  }
}
