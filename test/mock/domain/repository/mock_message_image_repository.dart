import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/message_image.dart';
import 'package:runnoter/domain/repository/message_image_repository.dart';

class MockMessageImageRepository extends Mock
    implements MessageImageRepository {
  void mockGetImagesByMessageId({
    required Stream<List<MessageImage>> imagesStream,
  }) {
    when(
      () => getImagesByMessageId(messageId: any(named: 'messageId')),
    ).thenAnswer((_) => imagesStream);
  }

  void mockGetImagesForChat({
    required Stream<List<MessageImage>> imagesStream,
  }) {
    when(
      () => getImagesForChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => imagesStream);
  }

  void mockLoadOlderImagesForChat() {
    when(
      () => loadOlderImagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleImageId: any(named: 'lastVisibleImageId'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockAddImagesInOrderToMessage() {
    when(
      () => addImagesInOrderToMessage(
        messageId: any(named: 'messageId'),
        bytesOfImages: any(named: 'bytesOfImages'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteAllImagesFromChat() {
    when(
      () => deleteAllImagesFromChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => Future.value());
  }
}
