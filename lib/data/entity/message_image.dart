import 'dart:typed_data';

import '../../domain/entity/entity.dart';

class MessageImage extends Entity {
  final String messageId;
  final int order;
  final Uint8List bytes;

  const MessageImage({
    required super.id,
    required this.messageId,
    required this.order,
    required this.bytes,
  }) : assert(order > 0);

  @override
  List<Object?> get props => [id, messageId, order, bytes];
}
