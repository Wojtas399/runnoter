import 'dart:typed_data';

import 'package:firebase/firebase.dart';

import '../../dependency_injection.dart';
import '../../domain/additional_model/custom_exception.dart';
import '../../domain/additional_model/state_repository.dart';
import '../../domain/entity/message_image.dart';
import '../../domain/repository/message_image_repository.dart';
import '../mapper/message_image_mapper.dart';

class MessageImageRepositoryImpl extends StateRepository<MessageImage>
    implements MessageImageRepository {
  final FirebaseMessageService _dbMessageService;
  final FirebaseMessageImageService _dbMessageImageService;
  final FirebaseStorageService _dbStorageService;

  MessageImageRepositoryImpl({super.initialData})
      : _dbMessageService = getIt<FirebaseMessageService>(),
        _dbMessageImageService = getIt<FirebaseMessageImageService>(),
        _dbStorageService = getIt<FirebaseStorageService>();

  @override
  Stream<List<MessageImage>> getImagesByMessageId({
    required final String messageId,
  }) async* {
    await _loadImagesFromDbByMessageId(messageId);
    await for (final messageImages in dataStream$) {
      yield [
        ...?messageImages?.where(
          (MessageImage messageImage) => messageImage.messageId == messageId,
        ),
      ];
    }
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
    if (bytesOfImages.isEmpty) {
      throw const MessageImageException(
        code: MessageImageExceptionCode.listOfImageBytesIsEmpty,
      );
    }
    final MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    if (messageDto == null) {
      throw const MessageImageException(
        code: MessageImageExceptionCode.messageNotFound,
      );
    }
    final List<MessageImageDto> imageDtos = [];
    final List<MessageImage> addedMessageImages = [];
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
        addedMessageImages.add(MessageImage(
          id: imageId,
          messageId: messageId,
          order: order,
          bytes: imageBytes,
        ));
        order++;
      }
    }
    await _dbMessageImageService.addMessageImagesToChat(
      chatId: messageDto.chatId,
      imageDtos: imageDtos,
    );
    addOrUpdateEntities(addedMessageImages);
  }

  Future<List<MessageImage>> _loadImagesFromDbByMessageId(
    String messageId,
  ) async {
    final MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    if (messageDto == null) return [];
    final List<MessageImageDto> imageDtos =
        await _dbMessageImageService.loadMessageImagesByMessageId(
      chatId: messageDto.chatId,
      messageId: messageId,
    );
    final List<MessageImage> images =
        await _loadImagesFromStorageForDtos(imageDtos);
    addOrUpdateEntities(images);
    return images;
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
