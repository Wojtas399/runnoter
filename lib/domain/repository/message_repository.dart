import '../entity/message.dart';

abstract interface class MessageRepository {
  Stream<List<Message>?> getMessagesForChat({required String chatId});
}
