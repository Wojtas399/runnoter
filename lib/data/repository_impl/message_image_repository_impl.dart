import 'dart:typed_data';

import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/entity/message_image.dart';
import '../../domain/repository/message_image_repository.dart';
import '../mapper/message_image_mapper.dart';

class MessageImageRepositoryImpl implements MessageImageRepository {
  final FirebaseMessageService _dbMessageService;
  final FirebaseStorageService _dbStorageService;

  MessageImageRepositoryImpl()
      : _dbMessageService = getIt<FirebaseMessageService>(),
        _dbStorageService = getIt<FirebaseStorageService>();

  @override
  Future<List<MessageImage>?> loadImagesByMessageId({
    required final String messageId,
  }) async {
    final MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    return messageDto == null
        ? null
        : await _loadImagesForMessageDto(messageDto);
  }

  @override
  Future<List<MessageImage>> loadImagesForChat({
    required String chatId,
    String? lastVisibleImageId,
  }) async {
    String? idOfMessageContainingImage;
    if (lastVisibleImageId != null) {
      final MessageDto? messageContainingImage = await _dbMessageService
          .loadMessageContainingImage(imageId: lastVisibleImageId);
      idOfMessageContainingImage = messageContainingImage?.id;
    }
    final List<MessageDto> messageWithImagesDtos =
        await _dbMessageService.loadMessagesWithImagesForChat(
      chatId: chatId,
      lastVisibleMessageId: idOfMessageContainingImage,
    );
    final List<MessageImage> images = [];
    for (final messageDto in messageWithImagesDtos) {
      final List<MessageImage> messageImages =
          await _loadImagesForMessageDto(messageDto);
      images.addAll(messageImages);
    }
    return images;
  }

  @override
  Future<String?> addImage({
    required final String messageId,
    required final Uint8List imageBytes,
  }) async =>
      await _dbStorageService.uploadMessageImage(
        messageId: messageId,
        imageBytes: imageBytes,
      );

  Future<List<MessageImage>> _loadImagesForMessageDto(
    final MessageDto messageDto,
  ) async {
    final List<MessageImage> images = [];
    for (final imageDto in messageDto.images) {
      final Uint8List? imageBytes = await _dbStorageService.loadMessageImage(
        messageId: messageDto.id,
        imageId: imageDto.id,
      );
      if (imageBytes != null) {
        images.add(mapMessageImageFromDto(
          messageImageDto: imageDto,
          messageId: messageDto.id,
          bytes: imageBytes,
        ));
      }
    }
    return images;
  }
}
