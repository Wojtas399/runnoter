import 'package:equatable/equatable.dart';

import '../../entity/message.dart';

class ChatGalleryState extends Equatable {
  final List<MessageImage>? images;
  final MessageImage? selectedImage;

  const ChatGalleryState({this.images, this.selectedImage});

  @override
  List<Object?> get props => [images, selectedImage];

  bool get isSelectedImageFirstOne {
    if (images == null || selectedImage == null) return false;
    final int selectedImageIndex = images!.indexOf(selectedImage!);
    return selectedImageIndex == 0;
  }

  bool get isSelectedImageLastOne {
    if (images == null || selectedImage == null) return false;
    final int selectedImageIndex = images!.indexOf(selectedImage!);
    return selectedImageIndex == images!.length - 1;
  }

  ChatGalleryState copyWith({
    List<MessageImage>? images,
    MessageImage? selectedImage,
  }) =>
      ChatGalleryState(
        images: images ?? this.images,
        selectedImage: selectedImage ?? this.selectedImage,
      );
}
