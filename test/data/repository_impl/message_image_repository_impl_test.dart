import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/repository_impl/message_image_repository_impl.dart';
import 'package:runnoter/domain/entity/message_image.dart';

import '../../creators/message_dto_creator.dart';
import '../../mock/firebase/mock_firebase_message_service.dart';
import '../../mock/firebase/mock_firebase_storage_service.dart';

void main() {
  final dbMessageService = MockFirebaseMessageService();
  final dbStorageService = MockFirebaseStorageService();
  late MessageImageRepositoryImpl repository;

  setUpAll(() {
    GetIt.I.registerFactory<FirebaseMessageService>(() => dbMessageService);
    GetIt.I.registerFactory<FirebaseStorageService>(() => dbStorageService);
  });

  setUp(() => repository = MessageImageRepositoryImpl());

  tearDown(() {
    reset(dbMessageService);
    reset(dbStorageService);
  });

  test(
    'load images by message id, '
    'message does not exist, '
    'should return null',
    () async {
      const String messageId = 'm1';
      dbMessageService.mockLoadMessageById();

      final List<MessageImage>? images = await repository.loadImagesByMessageId(
        messageId: messageId,
      );

      expect(images, null);
    },
  );

  test(
    'load images by message id, '
    'should load and return all images from message',
    () async {
      const String messageId = 'm1';
      final MessageDto messageDto = createMessageDto(
        id: messageId,
        dateTime: DateTime(2023),
        images: const [
          MessageImageDto(id: 'i1', order: 1),
          MessageImageDto(id: 'i2', order: 2),
        ],
      );
      final List<MessageImage> expectedImages = [
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
      ];
      dbMessageService.mockLoadMessageById(messageDto: messageDto);
      when(
        () => dbStorageService.loadMessageImage(
          messageId: messageId,
          imageId: 'i1',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(1)));
      when(
        () => dbStorageService.loadMessageImage(
          messageId: messageId,
          imageId: 'i2',
        ),
      ).thenAnswer((_) => Future.value(Uint8List(2)));

      final List<MessageImage>? images = await repository.loadImagesByMessageId(
        messageId: messageId,
      );

      expect(images, expectedImages);
      verify(
        () => dbMessageService.loadMessageById(messageId: messageId),
      ).called(1);
      verify(
        () => dbStorageService.loadMessageImage(
          messageId: messageId,
          imageId: 'i1',
        ),
      ).called(1);
      verify(
        () => dbStorageService.loadMessageImage(
          messageId: messageId,
          imageId: 'i2',
        ),
      ).called(1);
    },
  );

  test(
    'load images for chat, '
    'should load and return images from chat messages',
    () async {
      const String chatId = 'c1';
      const String lastVisibleImageId = 'i0';
      final MessageDto lastVisibleMessageDto = createMessageDto(id: 'm0');
      final List<MessageDto> messageDtos = [
        createMessageDto(
          id: 'm1',
          chatId: chatId,
          dateTime: DateTime(2023, 1, 1),
          images: const [
            MessageImageDto(id: 'i1', order: 1),
            MessageImageDto(id: 'i2', order: 2),
          ],
        ),
        createMessageDto(
          id: 'm2',
          chatId: chatId,
          dateTime: DateTime(2023, 1, 10),
          images: const [
            MessageImageDto(id: 'i3', order: 1),
          ],
        ),
        createMessageDto(
          id: 'm3',
          chatId: chatId,
          dateTime: DateTime(2023, 1, 20),
          images: const [
            MessageImageDto(id: 'i4', order: 1),
            MessageImageDto(id: 'i5', order: 2),
            MessageImageDto(id: 'i6', order: 3),
          ],
        ),
      ];
      final List<MessageImage> expectedImages = [
        MessageImage(id: 'i1', messageId: 'm1', order: 1, bytes: Uint8List(1)),
        MessageImage(id: 'i2', messageId: 'm1', order: 2, bytes: Uint8List(2)),
        MessageImage(id: 'i3', messageId: 'm2', order: 1, bytes: Uint8List(3)),
        MessageImage(id: 'i4', messageId: 'm3', order: 1, bytes: Uint8List(4)),
        MessageImage(id: 'i5', messageId: 'm3', order: 2, bytes: Uint8List(5)),
        MessageImage(id: 'i6', messageId: 'm3', order: 3, bytes: Uint8List(6)),
      ];
      dbMessageService.mockLoadMessageContainingImage(
        messageDto: lastVisibleMessageDto,
      );
      dbMessageService.mockLoadMessagesWithImagesForChat(
        messageDtos: messageDtos,
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
        () => dbMessageService.loadMessagesWithImagesForChat(
          chatId: chatId,
          lastVisibleMessageId: lastVisibleMessageDto.id,
        ),
      ).called(1);
    },
  );

  test(
    'add image, '
    'should upload image to db and return its id',
    () async {
      const String messageId = 'm1';
      final Uint8List imageBytes = Uint8List(1);
      const String expectedImageId = 'i1';
      dbStorageService.mockUploadMessageImage(imageId: expectedImageId);

      final String? imageId = await repository.addImage(
        messageId: messageId,
        imageBytes: imageBytes,
      );

      expect(imageId, expectedImageId);
      verify(
        () => dbStorageService.uploadMessageImage(
          messageId: messageId,
          imageBytes: imageBytes,
        ),
      ).called(1);
    },
  );
}
