import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/message_image_mapper.dart';
import 'package:runnoter/domain/entity/message_image.dart';

void main() {
  const messageImageId = 'i1';
  const int order = 1;
  const String messageId = 'm1';
  final Uint8List bytes = Uint8List(1);

  test(
    'map message image from dto',
    () {
      const MessageImageDto messageImageDto = MessageImageDto(
        id: messageImageId,
        order: order,
      );
      final MessageImage expectedMessageImage = MessageImage(
        id: messageImageId,
        messageId: messageId,
        order: order,
        bytes: bytes,
      );

      final MessageImage messageImage = mapMessageImageFromDto(
        messageImageDto: messageImageDto,
        messageId: messageId,
        bytes: bytes,
      );

      expect(messageImage, expectedMessageImage);
    },
  );
}
