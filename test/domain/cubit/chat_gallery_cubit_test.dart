import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/chat_gallery_cubit.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/entity/message_image.dart';
import 'package:runnoter/domain/repository/message_image_repository.dart';
import 'package:runnoter/domain/repository/message_repository.dart';

import '../../creators/message_creator.dart';
import '../../creators/message_image_creator.dart';
import '../../mock/domain/repository/mock_message_image_repository.dart';
import '../../mock/domain/repository/mock_message_repository.dart';

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
      final List<MessageImage> expectedMessageImages = [
        createMessageImage(id: 'i4', messageId: 'm3', order: 1),
        createMessageImage(id: 'i5', messageId: 'm3', order: 2),
        createMessageImage(id: 'i3', messageId: 'm2', order: 1),
        createMessageImage(id: 'i1', messageId: 'm1', order: 1),
        createMessageImage(id: 'i2', messageId: 'm1', order: 2),
      ];

      blocTest(
        'should load images for chat and sort them descending by message date time and ascending by order',
        build: () => ChatGalleryCubit(chatId: chatId),
        setUp: () {
          messageImageRepository.mockLoadImagesForChat(images: images);
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
        act: (cubit) => cubit.initialize(),
        expect: () => [
          expectedMessageImages,
        ],
      );
    },
  );
}
