import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/message.dart';
import '../../domain/repository/message_repository.dart';

class MessageRepositoryImpl extends StateRepository
    implements MessageRepository {
  @override
  Stream<List<Message>?> getMessagesForChat({
    required String chatId,
    required int page,
  }) {
    // TODO: implement getMessagesForChat
    throw UnimplementedError();
  }
}
