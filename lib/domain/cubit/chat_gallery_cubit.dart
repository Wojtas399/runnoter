import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../entity/message.dart';
import '../entity/message_image.dart';
import '../extensions/message_images_extensions.dart';
import '../repository/message_image_repository.dart';
import '../repository/message_repository.dart';

class ChatGalleryCubit extends Cubit<List<MessageImage>?> {
  final String chatId;
  final MessageImageRepository _messageImageRepository;
  final MessageRepository _messageRepository;

  ChatGalleryCubit({required this.chatId})
      : _messageImageRepository = getIt<MessageImageRepository>(),
        _messageRepository = getIt<MessageRepository>(),
        super(null);

  Future<void> initialize() async {
    final List<MessageImage> images =
        await _messageImageRepository.loadImagesForChat(chatId: chatId);
    final List<_MessageImages> imagesGroupedByMessage =
        await _groupImagesByMessage(images);
    final List<_MessageImages> imagesGroupedByMessageAndSortedBySendDateTime =
        _sortGroupedImagesDescendingBySendDateTime(imagesGroupedByMessage);
    emit(
      [
        for (final group in imagesGroupedByMessageAndSortedBySendDateTime)
          ...group.images.sortByOrder(),
      ],
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
