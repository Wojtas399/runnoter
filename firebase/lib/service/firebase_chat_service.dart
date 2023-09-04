import 'package:collection/collection.dart';

import '../firebase.dart';
import '../firebase_collections.dart';
import '../utils/utils.dart';

class FirebaseChatService {
  Future<ChatDto?> loadChatById({required String chatId}) async {
    final snapshot = await getChatsRef().doc(chatId).get();
    return snapshot.data();
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
}
