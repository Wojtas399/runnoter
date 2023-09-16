import 'dart:typed_data';

import '../entity/message_image.dart';

abstract interface class MessageImageRepository {
  Future<List<MessageImage>?> loadImagesByMessageId({
    required final String messageId,
  });

  Future<List<MessageImage>> loadImagesForChat({
    required final String chatId,
    final String? lastVisibleImageId,
  });

  Future<String?> addImage({
    required final String messageId,
    required final Uint8List imageBytes,
  });
}
