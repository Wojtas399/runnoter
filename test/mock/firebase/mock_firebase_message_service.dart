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

  void mockLoadMessageById({MessageDto? messageDto}) {
    when(
      () => loadMessageById(
        messageId: any(named: 'messageId'),
      ),
    ).thenAnswer((_) => Future.value(messageDto));
  }

  void mockLoadMessageContainingImage({MessageDto? messageDto}) {
    when(
      () => loadMessageContainingImage(
        imageId: any(named: 'imageId'),
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

  void mockLoadMessagesWithImagesForChat({List<MessageDto>? messageDtos}) {
    when(
      () => loadMessagesWithImagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ).thenAnswer((_) => Future.value(messageDtos));
  }

  void mockAddMessage({MessageDto? addedMessageDto}) {
    when(
      () => addMessage(
        chatId: any(named: 'chatId'),
        senderId: any(named: 'senderId'),
        dateTime: any(named: 'dateTime'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((_) => Future.value(addedMessageDto));
  }
}
