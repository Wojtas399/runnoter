import 'dart:typed_data';

import 'package:runnoter/domain/entity/message.dart';

MessageImage createMessageImage({
  String id = '',
  int order = 1,
  Uint8List? bytes,
}) =>
    MessageImage(
      id: id,
      order: order,
      bytes: bytes ?? Uint8List(1),
    );
