import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final Reference _storageRef;

  FirebaseStorageService() : _storageRef = FirebaseStorage.instance.ref();

  Future<Uint8List?> loadMessageImage({
    required String chatId,
    required String messageId,
    required String imageFileName,
  }) async {
    final String imagePath =
        _createPathForMessageImage(chatId, messageId, imageFileName);
    final imageRef = _storageRef.child(imagePath);
    return await imageRef.getData();
  }

  Future<String?> uploadMessageImage({
    required String chatId,
    required String messageId,
    required Uint8List imageData,
  }) async {
    const uuid = Uuid();
    final imageFileName = '${uuid.v4()}.jpg';
    final String imagePath =
        _createPathForMessageImage(chatId, messageId, imageFileName);
    final imageRef = _storageRef.child(imagePath);
    try {
      await imageRef.putData(imageData);
      return imageFileName;
    } catch (_) {
      return null;
    }
  }

  String _createPathForMessageImage(
    String chatId,
    String messageId,
    String imageFileName,
  ) =>
      'ChatImages/$chatId/$messageId/$imageFileName';
}
