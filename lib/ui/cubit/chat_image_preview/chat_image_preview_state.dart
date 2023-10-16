part of 'chat_image_preview_cubit.dart';

class ChatImagePreviewState extends Equatable {
  final List<MessageImage>? images;
  final MessageImage? selectedImage;

  const ChatImagePreviewState({this.images, this.selectedImage});

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

  ChatImagePreviewState copyWith({
    List<MessageImage>? images,
    MessageImage? selectedImage,
  }) =>
      ChatImagePreviewState(
        images: images ?? this.images,
        selectedImage: selectedImage ?? this.selectedImage,
      );
}
