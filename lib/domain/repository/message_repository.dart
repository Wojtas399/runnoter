import '../entity/message.dart';

abstract interface class MessageRepository {
  Stream<List<Message>> getMessagesForChat({required String chatId});

  Future<void> loadOlderMessagesForChat({
    required String chatId,
    required String lastVisibleMessageId,
  });

  Future<void> addMessageToChat({
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
    List<MessageImage> images = const [],
  });
}
