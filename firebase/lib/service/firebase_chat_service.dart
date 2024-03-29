import 'package:collection/collection.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseChatService {
  Stream<ChatDto?> getChatById({required String chatId}) => getChatsRef()
      .doc(chatId)
      .snapshots()
      .map((docSnapshot) => docSnapshot.data());

  Future<List<ChatDto>> loadChatsContainingUser({
    required String userId,
  }) async {
    final snapshotOfChatsWithMatchingUser1 =
        await getChatsRef().where(user1IdField, isEqualTo: userId).get();
    final snapshotOfChatsWithMatchingUser2 =
        await getChatsRef().where(user2IdField, isEqualTo: userId).get();
    return [
      ...snapshotOfChatsWithMatchingUser1.docs.map((doc) => doc.data()),
      ...snapshotOfChatsWithMatchingUser2.docs.map((doc) => doc.data()),
    ];
  }

  Future<ChatDto?> loadChatByUsers({
    required String user1Id,
    required String user2Id,
  }) async {
    final snapshotOfChatsWithUser1 = await getChatsRef()
        .where(user1IdField, whereIn: [user1Id, user2Id]).get();
    final snapshotOfChatsWithUser2 = await getChatsRef()
        .where(user2IdField, whereIn: [user1Id, user2Id]).get();
    return [
      ...snapshotOfChatsWithUser1.docs.map((doc) => doc.data()),
      ...snapshotOfChatsWithUser2.docs.map((doc) => doc.data()),
    ].firstWhereOrNull(
      (ChatDto chat) {
        final List<String> userIds = [user1Id, user2Id];
        return userIds.contains(chat.user1Id) && userIds.contains(chat.user2Id);
      },
    );
  }

  Future<ChatDto?> addNewChat({
    required String user1Id,
    required String user2Id,
  }) async {
    final ChatDto? existingChat =
        await loadChatByUsers(user1Id: user1Id, user2Id: user2Id);
    if (existingChat != null) {
      throw const FirebaseDocumentException(
        code: FirebaseDocumentExceptionCode.documentAlreadyExists,
      );
    } else {
      final chatRef = getChatsRef().doc();
      final newChatDto = ChatDto(id: '', user1Id: user1Id, user2Id: user2Id);
      await asyncOrSyncCall(() => chatRef.set(newChatDto));
      final snapshot = await chatRef.get();
      return snapshot.data();
    }
  }

  Future<ChatDto?> updateChat({
    required String chatId,
    DateTime? user1LastTypingDateTime,
    DateTime? user2LastTypingDateTime,
  }) async {
    final docRef = getChatsRef().doc(chatId);
    final jsonToUpdate = createChatJsonToUpdate(
      user1LastTypingDateTime: user1LastTypingDateTime,
      user2LastTypingDateTime: user2LastTypingDateTime,
    );
    await docRef.update(jsonToUpdate);
    final docSnapshot = await docRef.get();
    return docSnapshot.data();
  }

  Future<void> deleteChat({required String chatId}) async {
    await getChatsRef().doc(chatId).delete();
  }
}
