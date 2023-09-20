import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {
  MockFirebaseStorageService() {
    registerFallbackValue(Uint8List(1));
  }

  void mockLoadMessageImage({Uint8List? imageData}) {
    when(
      () => loadMessageImage(
        messageId: any(named: 'messageId'),
        imageId: any(named: 'imageId'),
      ),
    ).thenAnswer((_) => Future.value(imageData));
  }

  void mockUploadMessageImage({String? imageId}) {
    when(
      () => uploadMessageImage(
        messageId: any(named: 'messageId'),
        imageBytes: any(named: 'imageBytes'),
      ),
    ).thenAnswer((_) => Future.value(imageId));
  }
}
