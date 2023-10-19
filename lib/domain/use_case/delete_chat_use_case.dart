import '../../data/interface/repository/message_repository.dart';
import '../../data/repository/chat/chat_repository.dart';
import '../../data/repository/message_image/message_image_repository.dart';
import '../../dependency_injection.dart';

class DeleteChatUseCase {
  final ChatRepository _chatRepository;
  final MessageRepository _messageRepository;
  final MessageImageRepository _messageImageRepository;

  DeleteChatUseCase()
      : _chatRepository = getIt<ChatRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        _messageImageRepository = getIt<MessageImageRepository>();

  Future<void> execute({required String chatId}) async {
    await _messageImageRepository.deleteAllImagesFromChat(chatId: chatId);
    await _messageRepository.deleteAllMessagesFromChat(chatId: chatId);
    await _chatRepository.deleteChat(chatId: chatId);
  }
}
