import 'dart:typed_data';

import 'package:runnoter/domain/entity/message_image.dart';

MessageImage createMessageImage({
  String id = '',
  String messageId = '',
  int order = 1,
  Uint8List? bytes,
}) =>
    MessageImage(
      id: id,
      messageId: messageId,
      order: order,
      bytes: bytes ?? Uint8List(1),
    );
