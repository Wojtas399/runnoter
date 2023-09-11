import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import 'entity.dart';

class Message extends Entity {
  final String chatId;
  final String senderId;
  final DateTime dateTime;
  final String? text;
  final List<MessageImage> images;

  const Message({
    required super.id,
    required this.chatId,
    required this.senderId,
    required this.dateTime,
    this.text,
    this.images = const [],
  }) : assert(text != null || images.length > 0);

  @override
  List<Object?> get props => [id, chatId, senderId, dateTime, text];
}

class MessageImage extends Equatable {
  final int order;
  final Uint8List data;

  const MessageImage({required this.order, required this.data})
      : assert(order > 0);

  @override
  List<Object?> get props => [order, data];
}
