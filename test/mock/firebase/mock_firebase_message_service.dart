import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessageService extends Mock
    implements FirebaseMessageService {
  MockFirebaseMessageService() {
    registerFallbackValue(MessageStatus.sent);
  }

  void mockGetAddedOrModifiedMessagesForChat({
    List<MessageDto>? messageDtos,
    Stream<List<MessageDto>>? messageDtosStream,
  }) {
    when(
      () => getAddedOrModifiedMessagesForChat(chatId: any(named: 'chatId')),
    ).thenAnswer(
      (_) => messageDtosStream ?? Stream.value(messageDtos),
    );
  }

  void mockLoadMessageById({MessageDto? messageDto}) {
    when(
      () => loadMessageById(
        messageId: any(named: 'messageId'),
      ),
    ).thenAnswer((_) => Future.value(messageDto));
  }

  void mockLoadMessagesForChat({List<MessageDto>? messageDtos}) {
    when(
      () => loadMessagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ).thenAnswer((_) => Future.value(messageDtos));
  }

  void mockAddMessage({MessageDto? addedMessageDto}) {
    when(
      () => addMessage(
        status: any(named: 'status'),
        chatId: any(named: 'chatId'),
        senderId: any(named: 'senderId'),
        dateTime: any(named: 'dateTime'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((_) => Future.value(addedMessageDto));
  }

  void mockUpdateMessageStatus({MessageDto? updatedMessage}) {
    when(
      () => updateMessageStatus(
        messageId: any(named: 'messageId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value(updatedMessage));
  }
}
