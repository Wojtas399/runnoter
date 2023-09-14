import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final Reference _storageRef;

  FirebaseStorageService() : _storageRef = FirebaseStorage.instance.ref();

  Future<Uint8List?> loadChatImage({
    required String chatId,
    required String imageFileName,
  }) async {
    final String imagePath = _createPathForChatImage(chatId, imageFileName);
    final imageRef = _storageRef.child(imagePath);
    return await imageRef.getData();
  }

  Future<String?> uploadChatImage({
    required String chatId,
    required Uint8List imageBytes,
  }) async {
    const uuid = Uuid();
    final imageFileName = '${uuid.v4()}.jpg';
    final String imagePath = _createPathForChatImage(chatId, imageFileName);
    final imageRef = _storageRef.child(imagePath);
    try {
      await imageRef.putData(imageBytes);
      return imageFileName;
    } catch (_) {
      return null;
    }
  }

  String _createPathForChatImage(String chatId, String imageFileName) =>
      'ChatImages/$chatId/$imageFileName';
}
