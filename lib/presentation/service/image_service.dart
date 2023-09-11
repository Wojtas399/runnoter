import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';

Future<List<Uint8List>> pickMultipleImages() async {
  final ImagePicker picker = ImagePicker();
  final List<XFile> imageFiles = await picker.pickMultiImage();
  final List<Uint8List> images = [];
  for (final xFile in imageFiles) {
    final Uint8List imageBytes = await xFile.readAsBytes();
    images.add(imageBytes);
  }
  return images;
}

Future<Uint8List?> capturePhoto() async {
  final ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);
  return await photo?.readAsBytes();
}
