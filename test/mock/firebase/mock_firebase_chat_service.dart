import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseChatService extends Mock implements FirebaseChatService {
  void mockGetChatById({required Stream<ChatDto?> chatDtoStream}) {
    when(
      () => getChatById(
        chatId: any(named: 'chatId'),
      ),
    ).thenAnswer((_) => chatDtoStream);
  }

  void mockLoadChatsContainingUser({required List<ChatDto> chatDtos}) {
    when(
      () => loadChatsContainingUser(userId: any(named: 'userId')),
    ).thenAnswer((_) => Future.value(chatDtos));
  }

  void mockLoadChatByUsers({ChatDto? chatDto}) {
    when(
      () => loadChatByUsers(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      ),
    ).thenAnswer((invocation) => Future.value(chatDto));
  }

  void mockAddNewChat({ChatDto? addedChatDto, Object? throwable}) {
    if (throwable != null) {
      when(_addNewChatCall).thenThrow(throwable);
    } else {
      when(_addNewChatCall).thenAnswer((_) => Future.value(addedChatDto));
    }
  }

  void mockUpdateChat({ChatDto? updatedChatDto}) {
    when(
      () => updateChat(
        chatId: any(named: 'chatId'),
        user1LastTypingDateTime: any(named: 'user1LastTypingDateTime'),
        user2LastTypingDateTime: any(named: 'user2LastTypingDateTime'),
      ),
    ).thenAnswer((_) => Future.value(updatedChatDto));
  }

  void mockDeleteChat() {
    when(
      () => deleteChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => Future.value());
  }

  Future<ChatDto?> _addNewChatCall() => addNewChat(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      );
}
