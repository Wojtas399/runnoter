import 'dart:async';
import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:rxdart/rxdart.dart';

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
    required String messageId,
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
  Stream<List<MessageImage>> getImagesForChat({required String chatId}) {
    final StreamController<bool> canEmit$ = StreamController()..add(false);
    _loadImagesFromDbForChat(chatId).then((_) => canEmit$.add(true));
    StreamSubscription<List<MessageImageDto>?>? newImagesListener;
    return canEmit$.stream
        .switchMap(
          (bool canEmit) =>
              canEmit ? _getImagesFromChat(chatId) : Stream.value(null),
        )
        .whereNotNull()
        .doOnData(
          (_) => newImagesListener ??= _dbMessageImageService
              .getAddedImagesForChat(chatId: chatId)
              .whereNotNull()
              .listen(_manageNewImages),
        )
        .doOnCancel(() => newImagesListener?.cancel());
  }

  @override
  Future<void> loadOlderImagesForChat({
    required String chatId,
    required String lastVisibleImageId,
  }) async {
    await _loadImagesFromDbForChat(
      chatId,
      lastVisibleImageId: lastVisibleImageId,
    );
  }

  @override
  Future<void> addImagesInOrderToMessage({
    required String messageId,
    required List<Uint8List> bytesOfImages,
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

  @override
  Future<void> deleteImagesForChat({required String chatId}) async {
    //TODO
    throw UnimplementedError();
  }

  Future<void> _loadImagesFromDbByMessageId(String messageId) async {
    final MessageDto? messageDto =
        await _dbMessageService.loadMessageById(messageId: messageId);
    if (messageDto == null) return;
    final List<MessageImageDto> imageDtos =
        await _dbMessageImageService.loadMessageImagesByMessageId(
      chatId: messageDto.chatId,
      messageId: messageId,
    );
    final List<MessageImage> images =
        await _loadImagesFromStorageForDtos(imageDtos);
    addOrUpdateEntities(images);
  }

  Future<void> _loadImagesFromDbForChat(
    String chatId, {
    String? lastVisibleImageId,
  }) async {
    final imageDtos = await _dbMessageImageService.loadMessageImagesForChat(
      chatId: chatId,
      lastVisibleImageId: lastVisibleImageId,
    );
    final List<MessageImage> images =
        await _loadImagesFromStorageForDtos(imageDtos);
    addOrUpdateEntities(images);
  }

  Stream<List<MessageImage>?> _getImagesFromChat(String chatId) =>
      dataStream$.asyncMap(
        (images) async {
          final List<MessageImage> matchedImages = [];
          for (final image in [...?images]) {
            final messageDto = await _dbMessageService.loadMessageById(
              messageId: image.messageId,
            );
            if (messageDto?.chatId == chatId) matchedImages.add(image);
          }
          return matchedImages;
        },
      );

  Future<void> _manageNewImages(List<MessageImageDto> imageDtos) async {
    if (imageDtos.isNotEmpty) {
      final List<MessageImage> images =
          await _loadImagesFromStorageForDtos(imageDtos);
      addOrUpdateEntities(images);
    }
  }

  Future<List<MessageImage>> _loadImagesFromStorageForDtos(
    List<MessageImageDto> imageDtos,
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
