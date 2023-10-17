import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/interface/repository/message_image_repository.dart';
import 'package:runnoter/data/interface/repository/message_repository.dart';
import 'package:runnoter/data/model/message.dart';
import 'package:runnoter/data/model/message_image.dart';
import 'package:runnoter/ui/cubit/chat_gallery_cubit.dart';

import '../../creators/message_creator.dart';
import '../../creators/message_image_creator.dart';
import '../../mock/data/repository/mock_message_image_repository.dart';
import '../../mock/data/repository/mock_message_repository.dart';

void main() {
  final messageImageRepository = MockMessageImageRepository();
  final messageRepository = MockMessageRepository();
  const String chatId = 'c1';

  setUpAll(() {
    GetIt.I.registerSingleton<MessageImageRepository>(messageImageRepository);
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
  });

  tearDown(() {
    reset(messageImageRepository);
    reset(messageRepository);
  });

  group(
    'initialize',
    () {
      final List<MessageImage> images = [
        createMessageImage(id: 'i1', messageId: 'm1', order: 1),
        createMessageImage(id: 'i3', messageId: 'm2', order: 1),
        createMessageImage(id: 'i2', messageId: 'm1', order: 2),
      ];
      final List<MessageImage> updatedImages = [
        createMessageImage(id: 'i1', messageId: 'm1', order: 1),
        createMessageImage(id: 'i3', messageId: 'm2', order: 1),
        createMessageImage(id: 'i5', messageId: 'm3', order: 2),
        createMessageImage(id: 'i2', messageId: 'm1', order: 2),
        createMessageImage(id: 'i4', messageId: 'm3', order: 1),
      ];
      final Message m1Message = createMessage(
        id: 'm1',
        dateTime: DateTime(2023, 1, 10),
      );
      final Message m2Message = createMessage(
        id: 'm2',
        dateTime: DateTime(2023, 1, 12, 10, 30),
      );
      final Message m3Message = createMessage(
        id: 'm3',
        dateTime: DateTime(2023, 1, 12, 12, 30),
      );
      final List<MessageImage> expectedImages = [
        createMessageImage(id: 'i3', messageId: 'm2', order: 1),
        createMessageImage(id: 'i1', messageId: 'm1', order: 1),
        createMessageImage(id: 'i2', messageId: 'm1', order: 2),
      ];
      final List<MessageImage> expectedUpdatedImages = [
        createMessageImage(id: 'i4', messageId: 'm3', order: 1),
        createMessageImage(id: 'i5', messageId: 'm3', order: 2),
        createMessageImage(id: 'i3', messageId: 'm2', order: 1),
        createMessageImage(id: 'i1', messageId: 'm1', order: 1),
        createMessageImage(id: 'i2', messageId: 'm1', order: 2),
      ];
      final StreamController<List<MessageImage>> images$ = StreamController()
        ..add(images);

      blocTest(
        'should set listener of images for chat and sort them descending by message date time and ascending by order',
        build: () => ChatGalleryCubit(chatId: chatId),
        setUp: () {
          messageImageRepository.mockGetImagesForChat(
            imagesStream: images$.stream,
          );
          when(
            () => messageRepository.loadMessageById(messageId: 'm1'),
          ).thenAnswer((_) => Future.value(m1Message));
          when(
            () => messageRepository.loadMessageById(messageId: 'm2'),
          ).thenAnswer((_) => Future.value(m2Message));
          when(
            () => messageRepository.loadMessageById(messageId: 'm3'),
          ).thenAnswer((_) => Future.value(m3Message));
        },
        act: (cubit) {
          cubit.initialize();
          images$.add(updatedImages);
        },
        expect: () => [
          expectedImages,
          expectedUpdatedImages,
        ],
      );
    },
  );

  blocTest(
    'load older images, '
    'images list is null, '
    'should do nothing',
    build: () => ChatGalleryCubit(chatId: chatId),
    setUp: () => messageImageRepository.mockLoadOlderImagesForChat(),
    act: (cubit) => cubit.loadOlderImages(),
    expect: () => [],
    verify: (_) => verifyNever(
      () => messageImageRepository.loadOlderImagesForChat(
        chatId: chatId,
        lastVisibleImageId: any(named: 'lastVisibleImageId'),
      ),
    ),
  );

  blocTest(
    'load older images, '
    'images list is empty, '
    'should do nothing',
    build: () => ChatGalleryCubit(chatId: chatId, initialState: []),
    setUp: () => messageImageRepository.mockLoadOlderImagesForChat(),
    act: (cubit) => cubit.loadOlderImages(),
    expect: () => [],
    verify: (_) => verifyNever(
      () => messageImageRepository.loadOlderImagesForChat(
        chatId: chatId,
        lastVisibleImageId: any(named: 'lastVisibleImageId'),
      ),
    ),
  );

  blocTest(
    'load older images, '
    'should call message image repository method to load older images with '
    'id of the last image in list assigned to id of the last visible image param',
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: [
        createMessageImage(id: 'i1'),
        createMessageImage(id: 'i2'),
        createMessageImage(id: 'i3'),
      ],
    ),
    setUp: () => messageImageRepository.mockLoadOlderImagesForChat(),
    act: (cubit) => cubit.loadOlderImages(),
    expect: () => [],
    verify: (_) => verify(
      () => messageImageRepository.loadOlderImagesForChat(
        chatId: chatId,
        lastVisibleImageId: 'i3',
      ),
    ).called(1),
  );
}
