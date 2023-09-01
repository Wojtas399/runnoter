import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/message.dart';
import '../../domain/repository/message_repository.dart';
import '../mapper/message_mapper.dart';

class MessageRepositoryImpl extends StateRepository<Message>
    implements MessageRepository {
  final FirebaseMessageService _firebaseMessageService;

  MessageRepositoryImpl({super.initialData})
      : _firebaseMessageService = getIt<FirebaseMessageService>();

  @override
  Stream<List<Message>?> getMessagesForChat({required String chatId}) async* {
    await _loadLatestMessagesForChatFromDb(chatId);
    await for (final messages in dataStream$) {
      yield messages
          ?.where((Message message) => message.chatId == chatId)
          .toList();
    }
  }

  Future<void> _loadLatestMessagesForChatFromDb(String chatId) async {
    final messageDtos =
        await _firebaseMessageService.loadMessagesForChat(chatId: chatId);
    final List<Message> messages = messageDtos.map(mapMessageFromDto).toList();
    addOrUpdateEntities(messages);
  }
}
