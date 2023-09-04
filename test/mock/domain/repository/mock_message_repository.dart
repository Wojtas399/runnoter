import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/repository/message_repository.dart';

class MockMessageRepository extends Mock implements MessageRepository {
  void mockGetMessagesForChat({
    List<Message> messages = const [],
    Stream<List<Message>>? messagesStream,
  }) {
    when(
      () => getMessagesForChat(
        chatId: any(named: 'chatId'),
      ),
    ).thenAnswer((_) => messagesStream ?? Stream.value(messages));
  }

  void mockLoadOlderMessagesForChat() {
    when(
      () => loadOlderMessagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleMessageId: any(named: 'lastVisibleMessageId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockAddMessageToChat() {
    when(
      () => addMessageToChat(
        chatId: any(named: 'chatId'),
        senderId: any(named: 'senderId'),
        content: any(named: 'content'),
        dateTime: any(named: 'dateTime'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
