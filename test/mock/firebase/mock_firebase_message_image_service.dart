import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseMessageImageService extends Mock
    implements FirebaseMessageImageService {
  void mockGetAddedImagesForChat({
    required Stream<List<MessageImageDto>?> imagesStream,
  }) {
    when(
      () => getAddedImagesForChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => imagesStream);
  }

  void mockLoadMessageImagesByMessageId({
    required final List<MessageImageDto> messageImageDtos,
  }) {
    when(
      () => loadMessageImagesByMessageId(
        chatId: any(named: 'chatId'),
        messageId: any(named: 'messageId'),
      ),
    ).thenAnswer((_) => Future.value(messageImageDtos));
  }

  void mockLoadLimitedMessageImagesForChat({
    required final List<MessageImageDto> messageImageDtos,
  }) {
    when(
      () => loadLimitedMessageImagesForChat(
        chatId: any(named: 'chatId'),
        lastVisibleImageId: any(named: 'lastVisibleImageId'),
      ),
    ).thenAnswer((_) => Future.value(messageImageDtos));
  }

  void mockLoadAllMessageImagesForChat({
    required List<MessageImageDto> messageImageDtos,
  }) {
    when(
      () => loadAllMessageImagesForChat(chatId: any(named: 'chatId')),
    ).thenAnswer((_) => Future.value(messageImageDtos));
  }

  void mockAddMessageImagesToChat() {
    when(
      () => addMessageImagesToChat(
        chatId: any(named: 'chatId'),
        imageDtos: any(named: 'imageDtos'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
