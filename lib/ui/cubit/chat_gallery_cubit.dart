import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/interface/repository/message_image_repository.dart';
import '../../data/interface/repository/message_repository.dart';
import '../../data/model/message.dart';
import '../../data/model/message_image.dart';
import '../../dependency_injection.dart';
import '../extensions/message_images_extensions.dart';

class ChatGalleryCubit extends Cubit<List<MessageImage>?> {
  final String chatId;
  final MessageImageRepository _messageImageRepository;
  final MessageRepository _messageRepository;
  StreamSubscription<List<MessageImage>>? _imagesListener;

  ChatGalleryCubit({required this.chatId, List<MessageImage>? initialState})
      : _messageImageRepository = getIt<MessageImageRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _imagesListener?.cancel();
    return super.close();
  }

  void initialize() {
    _imagesListener ??= _messageImageRepository
        .getImagesForChat(chatId: chatId)
        .asyncMap(_groupImagesByMessage)
        .map(_sortGroupedImagesDescendingBySendDateTime)
        .map(
          (List<_MessageImages> messagesWithImages) => <MessageImage>[
            for (final messageImages in messagesWithImages)
              ...messageImages.images.sortByOrder(),
          ],
        )
        .listen(emit);
  }

  Future<void> loadOlderImages() async {
    if (state == null || state!.isEmpty) return;
    final String lastVisibleImageId = state!.last.id;
    await _messageImageRepository.loadOlderImagesForChat(
      chatId: chatId,
      lastVisibleImageId: lastVisibleImageId,
    );
  }

  Future<List<_MessageImages>> _groupImagesByMessage(
    List<MessageImage> images,
  ) async {
    final List<_MessageImages> groupedImages = [];
    for (final image in images) {
      final int matchingGroupIndex = groupedImages.indexWhere(
        (group) => group.messageId == image.messageId,
      );
      if (matchingGroupIndex >= 0) {
        groupedImages[matchingGroupIndex].images.add(image);
      } else {
        final Message? message = await _messageRepository.loadMessageById(
          messageId: image.messageId,
        );
        if (message == null) continue;
        groupedImages.add(_MessageImages(
          messageId: message.id,
          sendDateTime: message.dateTime,
          images: [image],
        ));
      }
    }
    return groupedImages;
  }

  List<_MessageImages> _sortGroupedImagesDescendingBySendDateTime(
    List<_MessageImages> groupedImages,
  ) {
    final List<_MessageImages> sortedGroupedImages = [...groupedImages];
    sortedGroupedImages.sort(
      (g1, g2) => g1.sendDateTime.isBefore(g2.sendDateTime) ? 1 : -1,
    );
    return sortedGroupedImages;
  }
}

class _MessageImages {
  final String messageId;
  final DateTime sendDateTime;
  final List<MessageImage> images;

  const _MessageImages({
    required this.messageId,
    required this.sendDateTime,
    required this.images,
  });
}
