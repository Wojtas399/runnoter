import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessageService extends Mock
    implements FirebaseMessageService {
  void mockLoadMessagesForChat({List<MessageDto>? messageDtos}) {
    when(
      () => loadMessagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ).thenAnswer((invocation) => Future.value(messageDtos));
  }
}
