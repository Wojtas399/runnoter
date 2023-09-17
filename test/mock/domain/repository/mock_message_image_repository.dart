import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/message_image.dart';
import 'package:runnoter/domain/repository/message_image_repository.dart';

class MockMessageImageRepository extends Mock
    implements MessageImageRepository {
  void mockLoadImagesByMessageId({required List<MessageImage> images}) {
    when(
      () => loadImagesByMessageId(
        messageId: any(named: 'messageId'),
      ),
    ).thenAnswer((_) => Future.value(images));
  }

  void mockLoadImagesForChat({required List<MessageImage> images}) {
    when(
      () => loadImagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleImageId: any(named: 'lastVisibleImageId'),
      ),
    ).thenAnswer((_) => Future.value(images));
  }

  void mockAddImagesInOrderToMessage() {
    when(
      () => addImagesInOrderToMessage(
        messageId: any(named: 'messageId'),
        bytesOfImages: any(named: 'bytesOfImages'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
