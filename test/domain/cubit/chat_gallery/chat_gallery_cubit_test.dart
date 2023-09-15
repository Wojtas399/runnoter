import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/chat_gallery/chat_gallery_cubit.dart';
import 'package:runnoter/domain/cubit/chat_gallery/chat_gallery_state.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/repository/message_repository.dart';

import '../../../creators/message_creator.dart';
import '../../../creators/message_image_creator.dart';
import '../../../mock/domain/repository/mock_message_repository.dart';

void main() {
  final messageRepository = MockMessageRepository();
  const String chatId = 'c1';

  setUpAll(() {
    GetIt.I.registerSingleton<MessageRepository>(messageRepository);
  });

  tearDown(() {
    reset(messageRepository);
  });

  group(
    'initialize',
    () {
      final List<Message> messages = [
        createMessage(
          id: 'm1',
          images: [
            createMessageImage(id: 'i2', order: 2),
            createMessageImage(id: 'i1', order: 1),
          ],
        ),
        createMessage(
          id: 'm2',
          images: [
            createMessageImage(id: 'i3', order: 1),
          ],
        ),
        createMessage(id: 'm3'),
      ];
      final List<Message> updatedMessages = [
        createMessage(
          id: 'm1',
          images: [
            createMessageImage(id: 'i2', order: 2),
            createMessageImage(id: 'i1', order: 1),
          ],
        ),
        createMessage(
          id: 'm2',
          images: [
            createMessageImage(id: 'i3', order: 1),
          ],
        ),
        createMessage(id: 'm3'),
        createMessage(
          id: 'm4',
          images: [
            createMessageImage(id: 'i6', order: 3),
            createMessageImage(id: 'i4', order: 1),
            createMessageImage(id: 'i5', order: 2),
          ],
        ),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);

      blocTest(
        'should set listener of images bytes from chat messages sorted in appropriate order',
        build: () => ChatGalleryCubit(chatId: chatId),
        setUp: () {
          messageRepository.mockGetMessagesForChat(
            messagesStream: messages$.stream,
          );
        },
        act: (cubit) {
          cubit.initialize();
          messages$.add(updatedMessages);
        },
        expect: () => [
          ChatGalleryState(
            images: [
              createMessageImage(id: 'i1', order: 1),
              createMessageImage(id: 'i2', order: 2),
              createMessageImage(id: 'i3', order: 1),
            ],
          ),
          ChatGalleryState(
            images: [
              createMessageImage(id: 'i1', order: 1),
              createMessageImage(id: 'i2', order: 2),
              createMessageImage(id: 'i3', order: 1),
              createMessageImage(id: 'i4', order: 1),
              createMessageImage(id: 'i5', order: 2),
              createMessageImage(id: 'i6', order: 3),
            ],
          ),
        ],
      );
    },
  );

  blocTest(
    'image selected, '
    'images do not exist, '
    'should do nothing',
    build: () => ChatGalleryCubit(chatId: chatId),
    act: (cubit) => cubit.imageSelected('i2'),
    expect: () => [],
  );

  blocTest(
    'image selected, '
    'should assign image selected by id to selectedImage param',
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
        images: [
          createMessageImage(id: 'i1', order: 1),
          createMessageImage(id: 'i2', order: 2),
          createMessageImage(id: 'i3', order: 3),
        ],
      ),
    ),
    act: (cubit) => cubit.imageSelected('i2'),
    expect: () => [
      ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i2'),
      ),
    ),
    act: (cubit) => cubit.previousImage(),
    expect: () => [
      ChatGalleryState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ],
  );

  blocTest(
    'next image, '
    'images do not exist, '
    'should do nothing',
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
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
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i1'),
      ),
    ),
    act: (cubit) => cubit.nextImage(),
    expect: () => [
      ChatGalleryState(
        images: [createMessageImage(id: 'i1'), createMessageImage(id: 'i2')],
        selectedImage: createMessageImage(id: 'i2'),
      ),
    ],
  );
}
