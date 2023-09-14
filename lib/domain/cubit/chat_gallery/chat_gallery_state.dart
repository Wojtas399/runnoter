import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class ChatGalleryState extends Equatable {
  final List<Uint8List>? images;
  final Uint8List? selectedImage;

  const ChatGalleryState({this.images, this.selectedImage});

  @override
  List<Object?> get props => [images, selectedImage];

  ChatGalleryState copyWith({
    List<Uint8List>? images,
    Uint8List? selectedImage,
  }) =>
      ChatGalleryState(
        images: images ?? this.images,
        selectedImage: selectedImage ?? this.selectedImage,
      );
}
