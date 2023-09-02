import '../entity/message.dart';

abstract interface class MessageRepository {
  Stream<List<Message>> getMessagesForChat({required String chatId});

  Future<void> addMessageToChat({
    required String chatId,
    required String senderId,
    required String content,
    required DateTime dateTime,
  });
}
