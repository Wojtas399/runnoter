import 'package:collection/collection.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseChatService {
  Stream<ChatDto?> getChatById({required String chatId}) => getChatsRef()
      .doc(chatId)
      .snapshots()
      .map((docSnapshot) => docSnapshot.data());

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
      throw const FirebaseChatException(
        code: FirebaseChatExceptionCode.chatAlreadyExists,
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
}
