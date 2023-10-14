import 'dart:typed_data';

import 'package:firebase/firebase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/entity/message_image.dart';
import 'package:runnoter/data/mapper/message_image_mapper.dart';

void main() {
  const messageImageId = 'i1';
  const int order = 1;
  final DateTime sendDateTime = DateTime(2023, 1, 10);
  const String messageId = 'm1';
  final Uint8List bytes = Uint8List(1);

  test(
    'map message image from dto',
    () {
      final MessageImageDto messageImageDto = MessageImageDto(
        id: messageImageId,
        messageId: messageId,
        sendDateTime: sendDateTime,
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
        bytes: bytes,
      );

      expect(messageImage, expectedMessageImage);
    },
  );
}
