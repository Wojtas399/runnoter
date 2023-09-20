import '../entity/message.dart';

abstract interface class MessageRepository {
  Future<Message?> loadMessageById({required String messageId});

  Stream<List<Message>> getMessagesForChat({required String chatId});

  Future<void> loadOlderMessagesForChat({
    required String chatId,
    required String lastVisibleMessageId,
  });

  Future<String?> addMessage({
    required MessageStatus status,
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
  });
}
