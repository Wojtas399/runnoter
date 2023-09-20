import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseMessageService {
  Stream<List<MessageDto>?> getAddedMessagesForChat({
    required String chatId,
  }) {
    bool isFirstQuery = true;
    return getMessagesRef()
        .where(chatIdField, isEqualTo: chatId)
        .snapshots()
        .map(
      (QuerySnapshot<MessageDto> snapshot) {
        if (isFirstQuery) {
          isFirstQuery = false;
          return null;
        } else {
          return snapshot.docChanges
              .where((docChange) =>
                  docChange.type == DocumentChangeType.added &&
                  docChange.doc.data() != null)
              .map((docChange) => docChange.doc.data()!)
              .toList();
        }
      },
    );
  }

  Future<MessageDto?> loadMessageById({
    required String messageId,
  }) async {
    final messageRef = getMessagesRef().doc(messageId);
    final docSnapshot = await messageRef.get();
    return docSnapshot.data();
  }

  Future<List<MessageDto>> loadMessagesForChat({
    required String chatId,
    final String? lastVisibleMessageId,
  }) async {
    final Query<MessageDto> query = getMessagesRef()
        .where(chatIdField, isEqualTo: chatId)
        .orderBy(timestampField, descending: true);
    return await _loadLimitedImagesByQuery(
      query: query,
      lastVisibleMessageId: lastVisibleMessageId,
    );
  }

  Future<MessageDto?> addMessage({
    required MessageStatus status,
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    final String? text,
  }) async {
    final messageRef = getMessagesRef().doc();
    final messageDto = MessageDto(
      id: '',
      status: status,
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime,
      text: text,
    );
    await messageRef.set(messageDto);
    final docSnapshot = await messageRef.get();
    return docSnapshot.data();
  }

  Future<List<MessageDto>> _loadLimitedImagesByQuery({
    required Query<MessageDto> query,
    final String? lastVisibleMessageId,
  }) async {
    Query<MessageDto> limitedQuery = query.limit(20);
    if (lastVisibleMessageId != null) {
      final messageSnapshot =
          await getMessagesRef().doc(lastVisibleMessageId).get();
      limitedQuery = query.startAfterDocument(messageSnapshot).limit(20);
    }
    final messagesSnapshot = await limitedQuery.get();
    return messagesSnapshot.docs.map((snapshot) => snapshot.data()).toList();
  }
}
