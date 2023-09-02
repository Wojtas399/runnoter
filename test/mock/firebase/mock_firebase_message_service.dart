import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessageService extends Mock
    implements FirebaseMessageService {
  void mockGetAddedMessagesForChat({
    List<MessageDto>? addedMessageDtos,
    Stream<List<MessageDto>>? addedMessageDtosStream,
  }) {
    when(
      () => getAddedMessagesForChat(chatId: any(named: 'chatId')),
    ).thenAnswer(
      (_) => addedMessageDtosStream ?? Stream.value(addedMessageDtos),
    );
  }

  void mockLoadMessagesForChat({List<MessageDto>? messageDtos}) {
    when(
      () => loadMessagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ).thenAnswer((invocation) => Future.value(messageDtos));
  }
}
