import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../../data/entity/message.dart';
import '../../../../../data/entity/message_image.dart';
import '../../../../../data/interface/repository/message_image_repository.dart';
import '../../../../../data/interface/repository/message_repository.dart';
import '../../../../../dependency_injection.dart';
import '../../extensions/message_images_extensions.dart';

part 'chat_image_preview_state.dart';

class ChatImagePreviewCubit extends Cubit<ChatImagePreviewState> {
  final MessageRepository _messageRepository;
  final MessageImageRepository _messageImageRepository;
  final String _chatId;
  StreamSubscription<List<MessageImage>?>? _imagesListener;

  ChatImagePreviewCubit({
    required String chatId,
    ChatImagePreviewState initialState = const ChatImagePreviewState(),
  })  : _messageRepository = getIt<MessageRepository>(),
        _messageImageRepository = getIt<MessageImageRepository>(),
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
        .map(_sortMessagesDescendingByDateTime)
        .switchMap(_getImagesForEachMessage)
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

  List<Message> _sortMessagesDescendingByDateTime(List<Message> messages) {
    final List<Message> sortedMessages = [...messages];
    sortedMessages.sort(
      (msg1, msg2) => msg1.dateTime.isBefore(msg2.dateTime) ? 1 : -1,
    );
    return sortedMessages;
  }

  Stream<List<MessageImage>> _getImagesForEachMessage(
    List<Message> messages,
  ) =>
      Rx.combineLatest(
        messages.map(_getSortedImagesForMessage),
        (List<List<MessageImage>> imagesForEachMessage) => [
          for (final messageImages in imagesForEachMessage) ...messageImages,
        ],
      );

  Stream<List<MessageImage>> _getSortedImagesForMessage(Message message) =>
      _messageImageRepository
          .getImagesByMessageId(messageId: message.id)
          .map((messageImages) => messageImages.sortByOrder());
}
