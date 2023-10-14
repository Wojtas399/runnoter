import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/message.dart';
import 'package:runnoter/domain/repository/message_repository.dart';

class MockMessageRepository extends Mock implements MessageRepository {
  MockMessageRepository() {
    registerFallbackValue(MessageStatus.sent);
  }

  void mockLoadMessageById({Message? message}) {
    when(
      () => loadMessageById(messageId: any(named: 'messageId')),
    ).thenAnswer((_) => Future.value(message));
  }

  void mockGetMessagesForChat({
    List<Message> messages = const [],
    Stream<List<Message>>? messagesStream,
  }) {
    when(
      () => getMessagesForChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => messagesStream ?? Stream.value(messages));
  }

  void mockDoesUserHaveUnreadMessagesInChat({required Stream<bool> expected$}) {
    when(
      () => doesUserHaveUnreadMessagesInChat(
        chatId: any(named: 'chatId'),
        userId: any(named: 'userId'),
      ),
    ).thenAnswer((_) => expected$);
  }

  void mockLoadOlderMessagesForChat() {
    when(
      () => loadOlderMessagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockAddMessage({String? addedMessageId}) {
    when(
      () => addMessage(
        status: any(named: 'status'),
        chatId: any(named: 'chatId'),
        senderId: any(named: 'senderId'),
        dateTime: any(named: 'dateTime'),
        text: any(named: 'text'),
      ),
    ).thenAnswer((_) => Future.value(addedMessageId));
  }

  void mockMarkMessagesAsRead() {
    when(
      () => markMessagesAsRead(messageIds: any(named: 'messageIds')),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteAllMessagesFromChat() {
    when(
      () => deleteAllMessagesFromChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => Future.value());
  }
}
