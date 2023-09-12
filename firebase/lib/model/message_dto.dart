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

  MessageDto.fromJson({
    required String messageId,
    required String chatId,
    required Map<String, dynamic>? json,
  }) : this(
          id: messageId,
          chatId: chatId,
          senderId: json?[_senderIdField],
          dateTime: DateTime.fromMillisecondsSinceEpoch(json?[timestampField]),
          text: json?[_textField],
          images: (json?[_imagesField] as List)
              .map((json) => MessageImageDto.fromJson(json))
              .toList(),
        );

  @override
  List<Object?> get props => [id, chatId, senderId, dateTime, text, images];

  Map<String, dynamic> toJson() => {
        _senderIdField: senderId,
        timestampField: dateTime.millisecondsSinceEpoch,
        _textField: text,
        _imagesField: images.map((imageDto) => imageDto.toJson()).toList(),
      };
}

const String _senderIdField = 'senderId';
const String timestampField = 'timestamp';
const String _textField = 'text';
const String _imagesField = 'images';
