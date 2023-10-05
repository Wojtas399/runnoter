import 'dart:async';
import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/message_image_repository_impl.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/entity/message_image.dart';

import '../../creators/message_dto_creator.dart';
import '../../creators/message_image_creator.dart';
import '../../creators/message_image_dto_creator.dart';
import '../../mock/firebase/mock_firebase_message_image_service.dart';
import '../../mock/firebase/mock_firebase_message_service.dart';
import '../../mock/firebase/mock_firebase_storage_service.dart';

void main() {
  final dbMessageService = MockFirebaseMessageService();
  final dbMessageImageService = MockFirebaseMessageImageService();
  final dbStorageService = MockFirebaseStorageService();
  late MessageImageRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseMessageService>(() => dbMessageService);
    GetIt.I.registerFactory<FirebaseMessageImageService>(
      () => dbMessageImageService,
    );
    GetIt.I.registerFactory<FirebaseStorageService>(() => dbStorageService);
  });

  setUp(() => repository = MessageImageRepositoryImpl());

  tearDown(() {
    reset(dbMessageService);
    reset(dbMessageImageService);
    reset(dbStorageService);
  });

  test(
    'get images by message id, '
    'should load new images from db, add them to repo and '
    'should emit all message images with given message id',
    () {
      const String messageId = 'm1';
      const String chatId = 'c1';
      final MessageDto messageDto = createMessageDto(
        id: messageId,
        chatId: chatId,
      );
      final List<MessageImage> existingMessageImages = [
        createMessageImage(id: 'i1', messageId: messageId),
        createMessageImage(id: 'i2', messageId: 'm2'),
        createMessageImage(id: 'i3', messageId: 'm3'),
      ];
      final List<MessageImageDto> loadedMessageImageDtos = [
        MessageImageDto(
          id: 'i4',
          messageId: messageId,
          sendDateTime: DateTime(2023, 1, 10),
          order: 1,
        ),
        MessageImageDto(
          id: 'i5',
          messageId: messageId,
          sendDateTime: DateTime(2023, 1, 12),
          order: 2,
        ),
      ];
      final List<MessageImage> loadedMessageImages = [
        MessageImage(
          id: 'i4',
          messageId: messageId,
          order: 1,
          bytes: Uint8List(1),
        ),
        MessageImage(
          id: 'i5',
          messageId: messageId,
          order: 2,
          bytes: Uint8List(2),
        ),
      ];
      dbMessageService.mockLoadMessageById(messageDto: messageDto);
      dbMessageImageService.mockLoadMessageImagesByMessageId(
        messageImageDtos: loadedMessageImageDtos,
      );
      when(
        () => dbStorageService.loadMessageImage(
          messageId: messageId,
          imageId: 'i4',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(1)));
      when(
        () => dbStorageService.loadMessageImage(
          messageId: messageId,
          imageId: 'i5',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(2)));
      repository = MessageImageRepositoryImpl(
        initialData: existingMessageImages,
      );

      final Stream<List<MessageImage>> messageImages$ =
          repository.getImagesByMessageId(messageId: messageId);

      expect(
        messageImages$,
        emitsInOrder([
          [existingMessageImages.first, ...loadedMessageImages],
        ]),
      );
      expect(
        repository.dataStream$,
        emitsInOrder([
          existingMessageImages,
          [...existingMessageImages, ...loadedMessageImages]
        ]),
      );
    },
  );

  test(
    'get images for chat, '
    'should load limited images from db, add them to repo and '
    'should listen and emit all existing and newly added images with matching with matching chat id',
    () {
      const String chatId = 'c1';
      final List<MessageImage> existingImages = [
        createMessageImage(id: 'i1', messageId: 'm1', order: 1),
        createMessageImage(id: 'i2', messageId: 'm2', order: 1),
        createMessageImage(id: 'i3', messageId: 'm3', order: 1),
      ];
      final List<MessageImageDto> loadedImageDtos = [
        MessageImageDto(
          id: 'i4',
          messageId: 'm1',
          sendDateTime: DateTime(2023, 1, 10),
          order: 2,
        ),
        MessageImageDto(
          id: 'i5',
          messageId: 'm4',
          sendDateTime: DateTime(2023, 1, 12),
          order: 1,
        ),
      ];
      final List<MessageImage> loadedImages = [
        MessageImage(
          id: 'i4',
          messageId: 'm1',
          order: 2,
          bytes: Uint8List(1),
        ),
        MessageImage(
          id: 'i5',
          messageId: 'm4',
          order: 1,
          bytes: Uint8List(2),
        ),
      ];
      final MessageImageDto firstAddedImageDto =
          createMessageImageDto(id: 'i6', messageId: 'm5');
      final MessageImageDto secondAddedImageDto =
          createMessageImageDto(id: 'i7', messageId: 'm6');
      final MessageImage firstAddedImage =
          createMessageImage(id: 'i6', messageId: 'm5', bytes: Uint8List(3));
      final MessageImage secondAddedImage =
          createMessageImage(id: 'i7', messageId: 'm6', bytes: Uint8List(4));
      final StreamController<List<MessageImageDto>> addedImages$ =
          StreamController()..add([]);
      dbMessageImageService.mockLoadLimitedMessageImagesForChat(
        messageImageDtos: loadedImageDtos,
      );
      dbMessageImageService.mockGetAddedImagesForChat(
        imagesStream: addedImages$.stream,
      );
      dbMessageService.mockLoadMessageById(
        messageDto: createMessageDto(chatId: chatId),
      );
      when(
        () => dbMessageService.loadMessageById(messageId: 'm2'),
      ).thenAnswer((_) => Future.value(createMessageDto(chatId: 'c2')));
      when(
        () => dbMessageService.loadMessageById(messageId: 'm3'),
      ).thenAnswer((_) => Future.value(createMessageDto(chatId: 'c3')));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm1', imageId: 'i4'),
      ).thenAnswer((_) => Future.value(Uint8List(1)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm4', imageId: 'i5'),
      ).thenAnswer((_) => Future.value(Uint8List(2)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm5', imageId: 'i6'),
      ).thenAnswer((_) => Future.value(Uint8List(3)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm6', imageId: 'i7'),
      ).thenAnswer((_) => Future.value(Uint8List(4)));
      repository = MessageImageRepositoryImpl(initialData: existingImages);

      final Stream<List<MessageImage>> messageImages$ =
          repository.getImagesForChat(chatId: chatId);
      addedImages$.add([firstAddedImageDto]);
      addedImages$.add([secondAddedImageDto]);

      expect(
        messageImages$,
        emitsInOrder([
          [existingImages.first, ...loadedImages],
          [existingImages.first, ...loadedImages, firstAddedImage],
          [
            existingImages.first,
            ...loadedImages,
            firstAddedImage,
            secondAddedImage,
          ],
        ]),
      );
      expect(
        repository.dataStream$,
        emitsInOrder([
          existingImages,
          [...existingImages, ...loadedImages],
          [...existingImages, ...loadedImages, firstAddedImage],
          [
            ...existingImages,
            ...loadedImages,
            firstAddedImage,
            secondAddedImage,
          ],
        ]),
      );
    },
  );

  test(
    'load older images for chat, '
    'should load limited images from db base on last visible image id and '
    'should add them to repo',
    () async {
      const String chatId = 'c1';
      const String lastVisibleImageId = 'i0';
      final List<MessageImage> existingImages = [
        createMessageImage(id: 'i1', messageId: 'm1'),
        createMessageImage(id: 'i2', messageId: 'm2'),
      ];
      final List<MessageImageDto> loadedImageDtos = [
        createMessageImageDto(id: 'i3', messageId: 'm3'),
        createMessageImageDto(id: 'i4', messageId: 'm4'),
      ];
      final List<MessageImage> loadedImages = [
        createMessageImage(id: 'i3', messageId: 'm3', bytes: Uint8List(3)),
        createMessageImage(id: 'i4', messageId: 'm4', bytes: Uint8List(4)),
      ];
      dbMessageImageService.mockLoadLimitedMessageImagesForChat(
        messageImageDtos: loadedImageDtos,
      );
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm3', imageId: 'i3'),
      ).thenAnswer((_) => Future.value(Uint8List(3)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm4', imageId: 'i4'),
      ).thenAnswer((_) => Future.value(Uint8List(4)));
      repository = MessageImageRepositoryImpl(initialData: existingImages);

      await repository.loadOlderImagesForChat(
        chatId: chatId,
        lastVisibleImageId: lastVisibleImageId,
      );

      expect(
        repository.dataStream$,
        emits([...existingImages, ...loadedImages]),
      );
      verify(
        () => dbMessageImageService.loadLimitedMessageImagesForChat(
          chatId: chatId,
          lastVisibleImageId: lastVisibleImageId,
        ),
      ).called(1);
    },
  );

  test(
    'add images in order to message, '
    'list of image bytes is empty, '
    'should throw message image exception with listOfImageBytesIsEmpty code',
    () async {
      const String messageId = 'm1';
      final List<Uint8List> bytesOfImages = [];
      dbMessageService.mockLoadMessageById();

      Object? exception;
      try {
        await repository.addImagesInOrderToMessage(
          messageId: messageId,
          bytesOfImages: bytesOfImages,
        );
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        const MessageImageException(
          code: MessageImageExceptionCode.listOfImageBytesIsEmpty,
        ),
      );
    },
  );

  test(
    'add images in order to message, '
    'message does not exist, '
    'should throw message image exception with messageNotFound code',
    () async {
      const String messageId = 'm1';
      final List<Uint8List> bytesOfImages = [
        Uint8List(1),
        Uint8List(2),
        Uint8List(3),
      ];
      dbMessageService.mockLoadMessageById();

      Object? exception;
      try {
        await repository.addImagesInOrderToMessage(
          messageId: messageId,
          bytesOfImages: bytesOfImages,
        );
      } catch (e) {
        exception = e;
      }

      expect(
        exception,
        const MessageImageException(
          code: MessageImageExceptionCode.messageNotFound,
        ),
      );
    },
  );

  test(
    'add images in order to message, '
    'should call db storage service method to upload images and '
    'should call db message image service method to add images to chat and '
    'should add new message images to repo',
    () async {
      const String messageId = 'm1';
      final List<Uint8List> bytesOfImages = [
        Uint8List(1),
        Uint8List(2),
        Uint8List(3),
      ];
      final MessageDto messageDto = createMessageDto(
        id: messageId,
        chatId: 'c1',
        dateTime: DateTime(2023, 1, 10),
      );
      final List<MessageImageDto> imageDtos = [
        MessageImageDto(
          id: 'i1',
          messageId: messageId,
          sendDateTime: DateTime(2023, 1, 10),
          order: 1,
        ),
        MessageImageDto(
          id: 'i2',
          messageId: messageId,
          sendDateTime: DateTime(2023, 1, 10),
          order: 2,
        ),
        MessageImageDto(
          id: 'i3',
          messageId: messageId,
          sendDateTime: DateTime(2023, 1, 10),
          order: 3,
        ),
      ];
      final List<MessageImage> expectedAddedMessageImages = [
        MessageImage(
          id: 'i1',
          messageId: messageId,
          order: 1,
          bytes: Uint8List(1),
        ),
        MessageImage(
          id: 'i2',
          messageId: messageId,
          order: 2,
          bytes: Uint8List(2),
        ),
        MessageImage(
          id: 'i3',
          messageId: messageId,
          order: 3,
          bytes: Uint8List(3),
        ),
      ];
      dbMessageService.mockLoadMessageById(messageDto: messageDto);
      when(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: bytesOfImages.first,
        ),
      ).thenAnswer((_) => Future.value('i1'));
      when(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: bytesOfImages[1],
        ),
      ).thenAnswer((_) => Future.value('i2'));
      when(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: bytesOfImages.last,
        ),
      ).thenAnswer((_) => Future.value('i3'));
      dbMessageImageService.mockAddMessageImagesToChat();

      await repository.addImagesInOrderToMessage(
        messageId: messageId,
        bytesOfImages: bytesOfImages,
      );

      expect(
        repository.dataStream$,
        emitsInOrder([expectedAddedMessageImages]),
      );
      verify(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: bytesOfImages.first,
        ),
      ).called(1);
      verify(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: bytesOfImages[1],
        ),
      ).called(1);
      verify(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: bytesOfImages.last,
        ),
      ).called(1);
      verify(
        () => dbMessageImageService.addMessageImagesToChat(
          chatId: messageDto.chatId,
          imageDtos: imageDtos,
        ),
      ).called(1);
    },
  );

  test(
    'delete all images from chat, '
    'should load all message images from db message image service and then '
    'should delete each image from db storage and from repo',
    () async {
      const String chatId = 'c1';
      final List<MessageImage> existingMessageImages = [
        createMessageImage(id: 'i11', messageId: 'm1'),
        createMessageImage(id: 'i12', messageId: 'm1'),
        createMessageImage(id: 'i21', messageId: 'm2'),
        createMessageImage(id: 'i31', messageId: 'm3'),
        createMessageImage(id: 'i41', messageId: 'm4'),
        createMessageImage(id: 'i42', messageId: 'm4'),
      ];
      final List<MessageImageDto> dtosOfMessageImagesFromChat = [
        createMessageImageDto(id: 'i11', messageId: 'm1'),
        createMessageImageDto(id: 'i12', messageId: 'm1'),
        createMessageImageDto(id: 'i21', messageId: 'm2'),
        createMessageImageDto(id: 'i31', messageId: 'm3'),
      ];
      dbMessageImageService.mockLoadAllMessageImagesForChat(
        messageImageDtos: dtosOfMessageImagesFromChat,
      );
      dbStorageService.mockDeleteMessageImage();
      repository = MessageImageRepositoryImpl(
        initialData: existingMessageImages,
      );

      await repository.deleteAllImagesFromChat(chatId: chatId);

      expect(
        repository.dataStream$,
        emits(existingMessageImages.slice(4)),
      );
      verify(
        () => dbMessageImageService.loadAllMessageImagesForChat(
          chatId: chatId,
        ),
      ).called(1);
      verify(
        () => dbStorageService.deleteMessageImage(
          messageId: 'm1',
          imageId: 'i11',
        ),
      ).called(1);
      verify(
        () => dbStorageService.deleteMessageImage(
          messageId: 'm1',
          imageId: 'i12',
        ),
      ).called(1);
      verify(
        () => dbStorageService.deleteMessageImage(
          messageId: 'm2',
          imageId: 'i21',
        ),
      ).called(1);
      verify(
        () => dbStorageService.deleteMessageImage(
          messageId: 'm3',
          imageId: 'i31',
        ),
      ).called(1);
    },
  );
}
