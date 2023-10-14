import 'dart:typed_data';

import '../../entity/message_image.dart';

abstract interface class MessageImageRepository {
  Stream<List<MessageImage>> getImagesByMessageId({required String messageId});

  Stream<List<MessageImage>> getImagesForChat({required String chatId});

  Future<void> loadOlderImagesForChat({
    required String chatId,
    required String lastVisibleImageId,
  });

  Future<void> addImagesInOrderToMessage({
    required String messageId,
    required List<Uint8List> bytesOfImages,
  });

  Future<void> deleteAllImagesFromChat({required String chatId});
}
