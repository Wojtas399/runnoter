import '../../dependency_injection.dart';
import '../repository/chat_repository.dart';
import '../repository/message_image_repository.dart';
import '../repository/message_repository.dart';

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