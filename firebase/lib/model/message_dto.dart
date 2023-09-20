import 'package:equatable/equatable.dart';

class MessageDto extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final DateTime dateTime;
  final String? text;

  const MessageDto({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.dateTime,
    this.text,
  });

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
    );
  }

  @override
  List<Object?> get props => [id, chatId, senderId, dateTime, text];

  Map<String, dynamic> toJson() => {
        chatIdField: chatId,
        _senderIdField: senderId,
        timestampField: dateTime.millisecondsSinceEpoch,
        _textField: text,
      };
}

const String chatIdField = 'chatId';
const String _senderIdField = 'senderId';
const String timestampField = 'timestamp';
const String _textField = 'text';
