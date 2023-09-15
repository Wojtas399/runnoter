import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../entity/message.dart';
import '../../repository/message_repository.dart';
import 'chat_gallery_state.dart';

class ChatGalleryCubit extends Cubit<ChatGalleryState> {
  final MessageRepository _messageRepository;
  final String _chatId;
  StreamSubscription<List<MessageImage>?>? _imagesListener;

  ChatGalleryCubit({
    required String chatId,
    ChatGalleryState initialState = const ChatGalleryState(),
  })  : _messageRepository = getIt<MessageRepository>(),
        _chatId = chatId,
        super(initialState);

  @override
  Future<void> close() {
    _imagesListener?.cancel();
    return super.close();
  }

  void initialize() {
    _imagesListener ??= _messageRepository
        .getMessagesForChat(chatId: _chatId)
        .map(_extractSortedImagesFromMessages)
        .listen(
          (List<MessageImage> images) => emit(state.copyWith(images: images)),
        );
  }

  void imageSelected(String imageId) {
    if (state.images == null) return;
    emit(state.copyWith(
      selectedImage: state.images!.firstWhere((image) => image.id == imageId),
    ));
  }

  void previousImage() {
    if (state.images == null || state.selectedImage == null) return;
    final int selectedImageIndex = state.images!.indexOf(state.selectedImage!);
    if (selectedImageIndex > 0) {
      emit(state.copyWith(
        selectedImage: state.images![selectedImageIndex - 1],
      ));
    }
  }

  void nextImage() {
    if (state.images == null || state.selectedImage == null) return;
    final int selectedImageIndex = state.images!.indexOf(state.selectedImage!);
    if (selectedImageIndex < state.images!.length - 1) {
      emit(state.copyWith(
        selectedImage: state.images![selectedImageIndex + 1],
      ));
    }
  }

  List<MessageImage> _extractSortedImagesFromMessages(List<Message> messages) {
    final imagesFromMessages = messages.map(_sortMessageImagesByOrder);
    return [for (final messageImages in imagesFromMessages) ...messageImages];
  }

  List<MessageImage> _sortMessageImagesByOrder(Message message) {
    final List<MessageImage> sortedImages = [...message.images];
    sortedImages.sortBy<num>((MessageImage image) => image.order);
    return sortedImages;
  }
}
