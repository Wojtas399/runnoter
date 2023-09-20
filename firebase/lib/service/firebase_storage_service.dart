import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class FirebaseStorageService {
  final Reference _storageRef;

  FirebaseStorageService() : _storageRef = FirebaseStorage.instance.ref();

  Future<Uint8List?> loadMessageImage({
    required String messageId,
    required String imageId,
  }) async {
    final String imagePath = _createPathForMessageImage(messageId, imageId);
    final imageRef = _storageRef.child(imagePath);
    return await imageRef.getData();
  }

  Future<String?> uploadMessageImage({
    required String messageId,
    required Uint8List imageBytes,
  }) async {
    const uuid = Uuid();
    final imageId = uuid.v4();
    final String imagePath = _createPathForMessageImage(messageId, imageId);
    final imageRef = _storageRef.child(imagePath);
    try {
      await imageRef.putData(imageBytes);
      return imageId;
    } catch (_) {
      return null;
    }
  }

  String _createPathForMessageImage(String messageId, String imageId) =>
      'MessageImages/$messageId/$imageId.jpg';
}
