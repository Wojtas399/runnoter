import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseMessageService {
  Stream<List<MessageDto>?> getAddedMessagesForChat({required String chatId}) {
    bool isFirstQuery = true;
    return getMessagesRef(chatId).snapshots().map(
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

  Future<List<MessageDto>> loadMessagesForChat({
    required String chatId,
    String? lastVisibleMessageId,
  }) async {
    final messagesRef = getMessagesRef(chatId).orderBy(
      timestampField,
      descending: true,
    );
    Query<MessageDto> query = messagesRef.limit(20);
    if (lastVisibleMessageId != null) {
      final messageSnapshot =
          await getMessagesRef(chatId).doc(lastVisibleMessageId).get();
      query = messagesRef.startAfterDocument(messageSnapshot).limit(20);
    }
    final messagesSnapshot = await query.get();
    return messagesSnapshot.docs.map((snapshot) => snapshot.data()).toList();
  }

  Future<MessageDto?> addMessageToChat({
    required String chatId,
    required String senderId,
    required DateTime dateTime,
    String? text,
  }) async {
    final messageRef = getMessagesRef(chatId).doc();
    final messageDto = MessageDto(
      id: '',
      chatId: chatId,
      senderId: senderId,
      dateTime: dateTime,
      text: text,
    );
    await messageRef.set(messageDto);
    final docSnapshot = await messageRef.get();
    return docSnapshot.data();
  }
}
