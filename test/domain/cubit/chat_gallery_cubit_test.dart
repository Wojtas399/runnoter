import 'dart:async';
import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/cubit/chat_gallery_cubit.dart';
import 'package:runnoter/domain/entity/message.dart';
import 'package:runnoter/domain/repository/message_repository.dart';

import '../../creators/message_creator.dart';
import '../../mock/domain/repository/mock_message_repository.dart';

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
            MessageImage(order: 2, data: Uint8List(2)),
            MessageImage(order: 1, data: Uint8List(1)),
          ],
        ),
        createMessage(
          id: 'm2',
          images: [
            MessageImage(order: 1, data: Uint8List(3)),
          ],
        ),
        createMessage(id: 'm3'),
      ];
      final List<Message> updatedMessages = [
        createMessage(
          id: 'm1',
          images: [
            MessageImage(order: 2, data: Uint8List(2)),
            MessageImage(order: 1, data: Uint8List(1)),
          ],
        ),
        createMessage(
          id: 'm2',
          images: [
            MessageImage(order: 1, data: Uint8List(3)),
          ],
        ),
        createMessage(id: 'm3'),
        createMessage(
          id: 'm4',
          images: [
            MessageImage(order: 3, data: Uint8List(6)),
            MessageImage(order: 1, data: Uint8List(4)),
            MessageImage(order: 2, data: Uint8List(5)),
          ],
        ),
      ];
      final StreamController<List<Message>> messages$ = StreamController()
        ..add(messages);

      blocTest(
        'should set listener of images data from chat messages sorted in appropriate order',
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
          [Uint8List(1), Uint8List(2), Uint8List(3)],
          [
            Uint8List(1),
            Uint8List(2),
            Uint8List(3),
            Uint8List(4),
            Uint8List(5),
            Uint8List(6),
          ],
        ],
      );
    },
  );
}
