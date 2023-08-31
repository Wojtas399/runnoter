import '../firebase_collections.dart';
import '../model/chat_dto.dart';
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
    final snapshot = await getChatsRef()
        .where(user1Id, whereIn: [user1Id, user2Id])
        .where(user2Id, whereIn: [user1Id, user2Id])
        .limit(1)
        .get();
    return snapshot.docs.isEmpty ? null : snapshot.docs.first.data();
  }

  Future<ChatDto?> addNewChat({
    required String user1Id,
    required String user2Id,
  }) async {
    final chatRef = getChatsRef().doc();
    final newChatDto = ChatDto(id: '', user1Id: user1Id, user2Id: user2Id);
    await asyncOrSyncCall(() => chatRef.set(newChatDto));
    final snapshot = await chatRef.get();
    return snapshot.data();
  }
}
