import 'dart:typed_data';

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
    'load images for chat, '
    'should load and return images from chat messages',
    () async {
      const String chatId = 'c1';
      const String lastVisibleImageId = 'i0';
      final List<MessageImageDto> messageImageDtos = [
        createMessageImageDto(id: 'i1', messageId: 'm1', order: 1),
        createMessageImageDto(id: 'i2', messageId: 'm1', order: 2),
        createMessageImageDto(id: 'i3', messageId: 'm2', order: 1),
        createMessageImageDto(id: 'i4', messageId: 'm3', order: 1),
        createMessageImageDto(id: 'i5', messageId: 'm3', order: 2),
        createMessageImageDto(id: 'i6', messageId: 'm3', order: 3),
      ];
      final List<MessageImage> expectedImages = [
        MessageImage(id: 'i1', messageId: 'm1', order: 1, bytes: Uint8List(1)),
        MessageImage(id: 'i2', messageId: 'm1', order: 2, bytes: Uint8List(2)),
        MessageImage(id: 'i3', messageId: 'm2', order: 1, bytes: Uint8List(3)),
        MessageImage(id: 'i4', messageId: 'm3', order: 1, bytes: Uint8List(4)),
        MessageImage(id: 'i5', messageId: 'm3', order: 2, bytes: Uint8List(5)),
        MessageImage(id: 'i6', messageId: 'm3', order: 3, bytes: Uint8List(6)),
      ];
      dbMessageImageService.mockLoadMessageImagesForChat(
        messageImageDtos: messageImageDtos,
      );
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm1', imageId: 'i1'),
      ).thenAnswer((_) => Future.value(Uint8List(1)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm1', imageId: 'i2'),
      ).thenAnswer((_) => Future.value(Uint8List(2)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm2', imageId: 'i3'),
      ).thenAnswer((_) => Future.value(Uint8List(3)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm3', imageId: 'i4'),
      ).thenAnswer((_) => Future.value(Uint8List(4)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm3', imageId: 'i5'),
      ).thenAnswer((_) => Future.value(Uint8List(5)));
      when(
        () => dbStorageService.loadMessageImage(messageId: 'm3', imageId: 'i6'),
      ).thenAnswer((_) => Future.value(Uint8List(6)));

      final List<MessageImage> images = await repository.loadImagesForChat(
        chatId: chatId,
        lastVisibleImageId: lastVisibleImageId,
      );

      expect(images, expectedImages);
      verify(
        () => dbMessageImageService.loadMessageImagesForChat(
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
}
