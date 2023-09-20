import 'package:equatable/equatable.dart';

import '../mapper/message_status_mapper.dart';

class MessageDto extends Equatable {
  final String id;
  final MessageStatus status;
  final String chatId;
  final String senderId;
  final DateTime dateTime;
  final String? text;

  const MessageDto({
    required this.id,
    required this.status,
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
      status: mapMessageStatusFromStr(json?[_messageStatusField]),
      chatId: json?[chatIdField],
      senderId: json?[_senderIdField],
      dateTime: sendDateTime,
      text: json?[_textField],
    );
  }

  @override
  List<Object?> get props => [id, chatId, senderId, dateTime, text];

  Map<String, dynamic> toJson() => {
        _messageStatusField: mapMessageStatusToString(status),
        chatIdField: chatId,
        _senderIdField: senderId,
        timestampField: dateTime.millisecondsSinceEpoch,
        _textField: text,
      };
}

enum MessageStatus { sent, read }

const String _messageStatusField = 'status';
const String chatIdField = 'chatId';
const String _senderIdField = 'senderId';
const String timestampField = 'timestamp';
const String _textField = 'text';
