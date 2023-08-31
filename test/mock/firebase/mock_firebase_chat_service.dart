import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseChatService extends Mock implements FirebaseChatService {
  void mockLoadChatById({ChatDto? chatDto}) {
    when(
      () => loadChatById(
        chatId: any(named: 'chatId'),
      ),
    ).thenAnswer((_) => Future.value(chatDto));
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

  Future<ChatDto?> _addNewChatCall() => addNewChat(
        user1Id: any(named: 'user1Id'),
        user2Id: any(named: 'user2Id'),
      );
}