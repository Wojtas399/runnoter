import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/message.dart';
import 'package:runnoter/data/entity/message_image.dart';
import 'package:runnoter/data/interface/repository/message_image_repository.dart';
import 'package:runnoter/data/interface/repository/message_repository.dart';
import 'package:runnoter/ui/feature/dialog/chat_image_preview/cubit/chat_image_preview_cubit.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../creators/message_creator.dart';
import '../../../../creators/message_image_creator.dart';
import '../../../../mock/domain/repository/mock_message_image_repository.dart';
import '../../../../mock/domain/repository/mock_message_repository.dart';

void main() {
  final messageRepository = MockMessageRepository();
  final messageImageRepository = MockMessageImageRepository();
  const String chatId = 'c1';

  setUpAll(() {
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
    GetIt.I.registerSingleton<MessageImageRepository>(messageImageRepository);
  });

  tearDown(() {
    reset(messageRepository);
    reset(messageImageRepository);
  });

  group(
    'initialize',
    () {
      final List<Message> messages = [
        createMessage(id: 'm3', dateTime: DateTime(2023, 1, 2)),
        createMessage(id: 'm2', dateTime: DateTime(2023, 1, 5)),
        createMessage(id: 'm1', dateTime: DateTime(2023, 1, 10)),
      ];
      final List<Message> updatedMessages = [
        createMessage(id: 'm3', dateTime: DateTime(2023, 1, 2, 12, 30)),
        createMessage(id: 'm2', dateTime: DateTime(2023, 1, 5)),
        createMessage(id: 'm1', dateTime: DateTime(2023, 1, 10)),
        createMessage(id: 'm4', dateTime: DateTime(2023, 1, 2, 10, 30)),
      ];
      final List<MessageImage> m1MessageImages = [
        createMessageImage(id: 'i2', order: 2),
        createMessageImage(id: 'i1', order: 1),
        createMessageImage(id: 'i3', order: 3),
      ];
      final List<MessageImage> m3MessageImages = [
        createMessageImage(id: 'i4', order: 1),
        createMessageImage(id: 'i5', order: 2),
      ];
      final List<MessageImage> m4MessageImages = [
        createMessageImage(id: 'i7', order: 2),
        createMessageImage(id: 'i6', order: 1),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);
      final StreamController<List<MessageImage>> m1MessageImages$ =
          BehaviorSubject.seeded(m1MessageImages);
      final StreamController<List<MessageImage>> m3MessageImages$ =
          BehaviorSubject.seeded(m3MessageImages);
      final StreamController<List<MessageImage>> m4MessageImages$ =
          BehaviorSubject.seeded(m4MessageImages);

      blocTest(
        'should set listener of messages from chat and sort them descending by date time and '
        'should set listener of message images and sort them by order',
        build: () => ChatImagePreviewCubit(chatId: chatId),
        setUp: () {
          messageRepository.mockGetMessagesForChat(
            messagesStream: messages$.stream,
          );
          messageImageRepository.mockGetImagesByMessageId(
            imagesStream: BehaviorSubject<List<MessageImage>>.seeded([]).stream,
          );
          when(
            () => messageImageRepository.getImagesByMessageId(messageId: 'm1'),
          ).thenAnswer((_) => m1MessageImages$.stream);
          when(
            () => messageImageRepository.getImagesByMessageId(messageId: 'm3'),
          ).thenAnswer((_) => m3MessageImages$.stream);
          when(
            () => messageImageRepository.getImagesByMessageId(messageId: 'm4'),
          ).thenAnswer((_) => m4MessageImages$.stream);
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          messages$.add(updatedMessages);
          await cubit.stream.first;
          m1MessageImages$.add([]);
          await cubit.stream.first;
          m4MessageImages$.add([]);
          await cubit.stream.first;
          m3MessageImages$.add([]);
        },
        expect: () => [
          ChatImagePreviewState(
            images: [
              createMessageImage(id: 'i1', order: 1),
              createMessageImage(id: 'i2', order: 2),
              createMessageImage(id: 'i3', order: 3),
              createMessageImage(id: 'i4', order: 1),
              createMessageImage(id: 'i5', order: 2),
            ],
          ),
          ChatImagePreviewState(
            images: [
              createMessageImage(id: 'i1', order: 1),
              createMessageImage(id: 'i2', order: 2),
              createMessageImage(id: 'i3', order: 3),
              createMessageImage(id: 'i4', order: 1),
              createMessageImage(id: 'i5', order: 2),
              createMessageImage(id: 'i6', order: 1),
              createMessageImage(id: 'i7', order: 2),
            ],
          ),
          ChatImagePreviewState(
            images: [
              createMessageImage(id: 'i4', order: 1),
              createMessageImage(id: 'i5', order: 2),
              createMessageImage(id: 'i6', order: 1),
              createMessageImage(id: 'i7', order: 2),
            ],
          ),
          ChatImagePreviewState(
            images: [
              createMessageImage(id: 'i4', order: 1),
              createMessageImage(id: 'i5', order: 2),
            ],
          ),
          const ChatImagePreviewState(images: []),
        ],
      );
    },
  );

  blocTest(
    'image selected, '
    'images do not exist, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(chatId: chatId),
    act: (cubit) => cubit.imageSelected('i2'),
    expect: () => [],
  );

  blocTest(
    'image selected, '
    'should assign image selected by id to selectedImage param',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [
          createMessageImage(id: 'i1', order: 1),
          createMessageImage(id: 'i2', order: 2),
          createMessageImage(id: 'i3', order: 3),
        ],
      ),
    ),
    act: (cubit) => cubit.imageSelected('i2'),
    expect: () => [
      ChatImagePreviewState(
        images: [
          createMessageImage(id: 'i1', order: 1),
          createMessageImage(id: 'i2', order: 2),
          createMessageImage(id: 'i3', order: 3),
        ],
        selectedImage: createMessageImage(id: 'i2', order: 2),
      ),
    ],
  );

  blocTest(
    'previous image, '
    'images do not exist, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ),
    act: (cubit) => cubit.previousImage(),
    expect: () => [],
  );

  blocTest(
    'previous image, '
    'selected image does not exist, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
      ),
    ),
    act: (cubit) => cubit.previousImage(),
    expect: () => [],
  );

  blocTest(
    'previous image, '
    'selected image is first in the list, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ),
    act: (cubit) => cubit.previousImage(),
    expect: () => [],
  );

  blocTest(
    'previous image, '
    'should assign previous image in the list to selectedImage param',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i2'),
      ),
    ),
    act: (cubit) => cubit.previousImage(),
    expect: () => [
      ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ],
  );

  blocTest(
    'next image, '
    'images do not exist, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ),
    act: (cubit) => cubit.nextImage(),
    expect: () => [],
  );

  blocTest(
    'next image, '
    'selected image does not exist, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
      ),
    ),
    act: (cubit) => cubit.nextImage(),
    expect: () => [],
  );

  blocTest(
    'next image, '
    'selected image is last in the list, '
    'should do nothing',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i2'),
      ),
    ),
    act: (cubit) => cubit.nextImage(),
    expect: () => [],
  );

  blocTest(
    'next image, '
    'should assign next image in the list to selectedImage param',
    build: () => ChatImagePreviewCubit(
      chatId: chatId,
      initialState: ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ),
    act: (cubit) => cubit.nextImage(),
    expect: () => [
      ChatImagePreviewState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i2'),
      ),
    ],
  );
}
