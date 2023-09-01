import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase.dart';
import '../firebase_collections.dart';

class FirebaseMessageService {
  Future<List<MessageDto>> loadMessagesForChat({
    required String chatId,
    String? lastVisibleMessageId,
  }) async {
    final messagesRef = getMessagesRef(chatId).orderBy(timestampField);
    Query<MessageDto> query = messagesRef.limit(20);
    if (lastVisibleMessageId != null) {
      final lastVisibleMessageSnapshot =
          await getMessagesRef(chatId).doc(lastVisibleMessageId).get();
      final lastVisibleMessageDto = lastVisibleMessageSnapshot.data();
      if (lastVisibleMessageDto != null) {
        query = messagesRef.startAfter([lastVisibleMessageDto]).limit(20);
      }
    }
    final messagesSnapshot = await query.get();
    return messagesSnapshot.docs.map((snapshot) => snapshot.data()).toList();
  }
}
