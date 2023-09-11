import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {
  void mockLoadMessageImage({Uint8List? imageData}) {
    when(
      () => loadMessageImage(
        chatId: any(named: 'chatId'),
        messageId: any(named: 'messageId'),
        imageFileName: any(named: 'imageFileName'),
      ),
    ).thenAnswer((_) => Future.value(imageData));
  }

  void mockUploadMessageImage({String? imageFileName}) {
    when(
      () => uploadMessageImage(
        chatId: any(named: 'chatId'),
        messageId: any(named: 'messageId'),
        imageData: any(named: 'imageData'),
      ),
    ).thenAnswer((_) => Future.value(imageFileName));
  }
}
