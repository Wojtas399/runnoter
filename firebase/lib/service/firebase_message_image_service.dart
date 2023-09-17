import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../model/message_image_dto.dart';

class FirebaseMessageImageService {
  Future<List<MessageImageDto>> loadMessageImagesByMessageId({
    required final String chatId,
    required final String messageId,
  }) async {
    final querySnapshot = await getMessageImagesRef(chatId)
        .where(messageIdField, isEqualTo: messageId)
        .get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<List<MessageImageDto>> loadMessageImagesForChat({
    required final String chatId,
    String? lastVisibleImageId,
  }) async {
    final Query<MessageImageDto> query = getMessageImagesRef(chatId)
        .orderBy(sendTimestampField, descending: true);
    Query<MessageImageDto> limitedQuery = query.limit(20);
    if (lastVisibleImageId != null) {
      final messageImageSnapshot =
          await getMessageImagesRef(chatId).doc(lastVisibleImageId).get();
      limitedQuery = query.startAfterDocument(messageImageSnapshot).limit(20);
    }
    final messageImagesSnapshot = await limitedQuery.get();
    return messageImagesSnapshot.docs
        .map((snapshot) => snapshot.data())
        .toList();
  }

  Future<void> addMessageImagesToChat({
    required final String chatId,
    required List<MessageImageDto> imageDtos,
  }) async {
    final messageImagesRef = getMessageImagesRef(chatId);
    for (final dto in imageDtos) {
      await messageImagesRef.add(dto);
    }
  }
}
