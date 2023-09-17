import 'dart:typed_data';

import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/custom_exception.dart';
import '../../domain/entity/message_image.dart';
import '../../domain/repository/message_image_repository.dart';
import '../mapper/message_image_mapper.dart';

class MessageImageRepositoryImpl implements MessageImageRepository {
  final FirebaseMessageService _dbMessageService;
  final FirebaseMessageImageService _dbMessageImageService;
  final FirebaseStorageService _dbStorageService;

  MessageImageRepositoryImpl()
      : _dbMessageService = getIt<FirebaseMessageService>(),
        _dbMessageImageService = getIt<FirebaseMessageImageService>(),
        _dbStorageService = getIt<FirebaseStorageService>();

  @override
  Future<List<MessageImage>> loadImagesByMessageId({
    required final String messageId,
  }) async {
    final MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    if (messageDto == null) return [];
    final List<MessageImageDto> imageDtos =
        await _dbMessageImageService.loadMessageImagesByMessageId(
      chatId: messageDto.chatId,
      messageId: messageId,
    );
    return await _loadImagesFromStorageForDtos(imageDtos);
  }

  @override
  Future<List<MessageImage>> loadImagesForChat({
    required final String chatId,
    final String? lastVisibleImageId,
  }) async {
    final List<MessageImageDto> imageDtos =
        await _dbMessageImageService.loadMessageImagesForChat(
      chatId: chatId,
      lastVisibleImageId: lastVisibleImageId,
    );
    return await _loadImagesFromStorageForDtos(imageDtos);
  }

  @override
  Future<void> addImagesInOrderToMessage({
    required final String messageId,
    required final List<Uint8List> bytesOfImages,
  }) async {
    final MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    if (messageDto == null) {
      throw const MessageImageException(
        code: MessageImageExceptionCode.messageNotFound,
      );
    }
    final List<MessageImageDto> imageDtos = [];
    int order = 1;
    for (final imageBytes in bytesOfImages) {
      final String? imageId = await _dbStorageService.uploadMessageImage(
        messageId: messageId,
        imageBytes: imageBytes,
      );
      if (imageId != null) {
        imageDtos.add(MessageImageDto(
          id: imageId,
          messageId: messageId,
          sendDateTime: messageDto.dateTime,
          order: order,
        ));
        order++;
      }
    }
    await _dbMessageImageService.addMessageImagesToChat(
      chatId: messageDto.chatId,
      imageDtos: imageDtos,
    );
  }

  Future<List<MessageImage>> _loadImagesFromStorageForDtos(
    final List<MessageImageDto> imageDtos,
  ) async {
    final List<MessageImage> images = [];
    for (final imageDto in imageDtos) {
      final Uint8List? imageBytes = await _dbStorageService.loadMessageImage(
        imageId: imageDto.id,
        messageId: imageDto.messageId,
      );
      if (imageBytes != null) {
        images.add(
          mapMessageImageFromDto(messageImageDto: imageDto, bytes: imageBytes),
        );
      }
    }
    return images;
  }
}
