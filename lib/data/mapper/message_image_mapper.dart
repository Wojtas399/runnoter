import 'dart:typed_data';

import 'package:firebase/firebase.dart';

import '../../domain/entity/message_image.dart';

MessageImage mapMessageImageFromDto({
  required final MessageImageDto messageImageDto,
  required final String messageId,
  required final Uint8List bytes,
}) =>
    MessageImage(
      id: messageImageDto.id,
      messageId: messageId,
      order: messageImageDto.order,
      bytes: bytes,
    );
