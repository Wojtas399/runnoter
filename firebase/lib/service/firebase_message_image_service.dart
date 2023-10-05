import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../model/message_image_dto.dart';

class FirebaseMessageImageService {
  Stream<List<MessageImageDto>?> getAddedImagesForChat({
    required final String chatId,
  }) {
    bool isFirstQuery = true;
    return getMessageImagesRef(chatId).snapshots().map(
      (QuerySnapshot<MessageImageDto> querySnapshot) {
        if (isFirstQuery) {
          isFirstQuery = false;
          return null;
        }
        return querySnapshot.docChanges
            .where((docChange) =>
                docChange.type == DocumentChangeType.added &&
                docChange.doc.data() != null)
            .map((docChange) => docChange.doc.data()!)
            .toList();
      },
    );
  }

  Future<List<MessageImageDto>> loadMessageImagesByMessageId({
    required final String chatId,
    required final String messageId,
  }) async {
    final querySnapshot = await getMessageImagesRef(chatId)
        .where(messageIdField, isEqualTo: messageId)
        .get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<List<MessageImageDto>> loadLimitedMessageImagesForChat({
    required final String chatId,
    String? lastVisibleImageId,
  }) async {
    final Query<MessageImageDto> query = getMessageImagesRef(chatId)
        .orderBy(sendTimestampField, descending: true);
    Query<MessageImageDto> limitedQuery = query.limit(20);
    if (lastVisibleImageId != null) {
      final messageImageSnapshot =
          await getMessageImagesRef(chatId).doc(lastVisibleImageId).get();
      limitedQuery = query.startAfterDocument(messageImageSnapshot).limit(50);
    }
    final messageImagesSnapshot = await limitedQuery.get();
    return messageImagesSnapshot.docs
        .map((snapshot) => snapshot.data())
        .toList();
  }

  Future<List<MessageImageDto>> loadAllMessageImagesForChat({
    required String chatId,
  }) async {
    final messageImages = await getMessageImagesRef(chatId).get();
    return messageImages.docs
        .map((querySnapshot) => querySnapshot.data())
        .toList();
  }

  Future<void> addMessageImagesToChat({
    required final String chatId,
    required List<MessageImageDto> imageDtos,
  }) async {
    final messageImagesRef = getMessageImagesRef(chatId);
    for (final dto in imageDtos) {
      await messageImagesRef.doc(dto.id).set(dto);
    }
  }

  Future<void> deleteAllMessageImagesFromChat({required String chatId}) async {
    final messageImages = await getMessageImagesRef(chatId).get();
    final batch = FirebaseFirestore.instance.batch();
    for (final messageImg in messageImages.docs) {
      batch.delete(messageImg.reference);
    }
    await batch.commit();
  }
}
