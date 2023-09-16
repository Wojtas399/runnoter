import 'package:equatable/equatable.dart';

import 'message_image_dto.dart';

class MessageDto extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final DateTime dateTime;
  final String? text;
  final List<MessageImageDto> images;

  const MessageDto({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.dateTime,
    this.text,
    this.images = const [],
  }) : assert(text != null || images.length > 0);

  factory MessageDto.fromJson({
    required final String messageId,
    required final Map<String, dynamic>? json,
  }) {
    final DateTime sendDateTime = DateTime.fromMillisecondsSinceEpoch(
      json?[timestampField],
    );
    return MessageDto(
      id: messageId,
      chatId: json?[chatIdField],
      senderId: json?[_senderIdField],
      dateTime: sendDateTime,
      text: json?[_textField],
      images: (json?[imagesField] as List)
          .map((json) => MessageImageDto.fromJson(json))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [id, chatId, senderId, dateTime, text, images];

  Map<String, dynamic> toJson() => {
        chatIdField: chatId,
        _senderIdField: senderId,
        timestampField: dateTime.millisecondsSinceEpoch,
        _textField: text,
        imagesField: images.map((imageDto) => imageDto.toJson()).toList(),
      };
}

const String chatIdField = 'chatId';
const String _senderIdField = 'senderId';
const String timestampField = 'timestamp';
const String _textField = 'text';
const String imagesField = 'images';
