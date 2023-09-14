import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseStorageService extends Mock
    implements FirebaseStorageService {
  void mockLoadChatImage({Uint8List? imageData}) {
    when(
      () => loadChatImage(
        chatId: any(named: 'chatId'),
        imageFileName: any(named: 'imageFileName'),
      ),
    ).thenAnswer((_) => Future.value(imageData));
  }

  void mockUploadChatImage({String? imageFileName}) {
    when(
      () => uploadChatImage(
        chatId: any(named: 'chatId'),
        imageBytes: any(named: 'imageBytes'),
      ),
    ).thenAnswer((_) => Future.value(imageFileName));
  }
}
