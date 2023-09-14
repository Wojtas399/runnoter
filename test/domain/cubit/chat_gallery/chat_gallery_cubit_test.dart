import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/chat_gallery/chat_gallery_cubit.dart';
import 'package:runnoter/domain/cubit/chat_gallery/chat_gallery_state.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/repository/message_repository.dart';

import '../../../creators/message_creator.dart';
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
            MessageImage(order: 2, bytes: Uint8List(2)),
            MessageImage(order: 1, bytes: Uint8List(1)),
          ],
        ),
        createMessage(
          id: 'm2',
          images: [
            MessageImage(order: 1, bytes: Uint8List(3)),
          ],
        ),
        createMessage(id: 'm3'),
      ];
      final List<Message> updatedMessages = [
        createMessage(
          id: 'm1',
          images: [
            MessageImage(order: 2, bytes: Uint8List(2)),
            MessageImage(order: 1, bytes: Uint8List(1)),
          ],
        ),
        createMessage(
          id: 'm2',
          images: [
            MessageImage(order: 1, bytes: Uint8List(3)),
          ],
        ),
        createMessage(id: 'm3'),
        createMessage(
          id: 'm4',
          images: [
            MessageImage(order: 3, bytes: Uint8List(6)),
            MessageImage(order: 1, bytes: Uint8List(4)),
            MessageImage(order: 2, bytes: Uint8List(5)),
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
            images: [Uint8List(1), Uint8List(2), Uint8List(3)],
          ),
          ChatGalleryState(
            images: [
              Uint8List(1),
              Uint8List(2),
              Uint8List(3),
              Uint8List(4),
              Uint8List(5),
              Uint8List(6),
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
    act: (cubit) => cubit.imageSelected(2),
    expect: () => [],
  );

  blocTest(
    'image selected, '
    'given index is out of list range, '
    'should do nothing',
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
        images: [Uint8List(1), Uint8List(2), Uint8List(3)],
      ),
    ),
    act: (cubit) => cubit.imageSelected(4),
    expect: () => [],
  );

  blocTest(
    'image selected, '
    'should assign  image at given index to selectedImage param',
    build: () => ChatGalleryCubit(
      chatId: chatId,
      initialState: ChatGalleryState(
        images: [Uint8List(1), Uint8List(2), Uint8List(3)],
      ),
    ),
    act: (cubit) => cubit.imageSelected(1),
    expect: () => [
      ChatGalleryState(
        images: [Uint8List(1), Uint8List(2), Uint8List(3)],
        selectedImage: Uint8List(2),
      ),
    ],
  );
}
