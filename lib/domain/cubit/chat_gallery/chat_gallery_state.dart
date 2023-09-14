import 'package:equatable/equatable.dart';

import '../../entity/message.dart';

class ChatGalleryState extends Equatable {
  final List<MessageImage>? images;
  final MessageImage? selectedImage;

  const ChatGalleryState({this.images, this.selectedImage});

  @override
  List<Object?> get props => [images, selectedImage];

  ChatGalleryState copyWith({
    List<MessageImage>? images,
    MessageImage? selectedImage,
  }) =>
      ChatGalleryState(
        images: images ?? this.images,
        selectedImage: selectedImage ?? this.selectedImage,
      );
}
