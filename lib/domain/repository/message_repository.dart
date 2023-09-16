import '../entity/message.dart';

abstract interface class MessageRepository {
  Stream<List<Message>> getMessagesForChat({required String chatId});

  Future<void> loadOlderMessagesForChat({
    required String chatId,
    required String lastVisibleMessageId,
  });

  Future<String?> addMessage({
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
  });
}
