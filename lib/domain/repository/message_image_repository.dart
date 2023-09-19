import 'dart:typed_data';

import '../entity/message_image.dart';

abstract interface class MessageImageRepository {
  Stream<List<MessageImage>> getImagesByMessageId({
    required final String messageId,
  });

  Stream<List<MessageImage>> getImagesForChat({
    required final String chatId,
  });

  Future<void> loadOlderImagesForChat({
    required final String chatId,
    final String? lastVisibleImageId,
  });

  Future<void> addImagesInOrderToMessage({
    required final String messageId,
    required final List<Uint8List> bytesOfImages,
  });
}
