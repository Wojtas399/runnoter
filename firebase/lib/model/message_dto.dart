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
        );

  @override
  List<Object?> get props => [id, chatId, senderId, dateTime, text];

  Map<String, dynamic> toJson() => {
        _senderIdField: senderId,
        timestampField: dateTime.millisecondsSinceEpoch,
        _textField: text,
      };
}

const String _senderIdField = 'senderId';
const String timestampField = 'timestamp';
const String _textField = 'text';
