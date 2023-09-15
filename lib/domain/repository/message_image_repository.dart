import 'dart:typed_data';

import '../entity/message_image.dart';

abstract interface class MessageImageRepository {
  Future<List<MessageImage>> loadImagesByMessageId({required String messageId});

  Future<List<MessageImage>> loadImagesByChatId({
    required String chatId,
    String? lastVisibleImageId,
  });

  Future<String> addImage({
    required String chatId,
    required String messageId,
    required int order,
    required Uint8List bytes,
  });
}
