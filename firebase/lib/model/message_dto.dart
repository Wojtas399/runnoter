import 'package:equatable/equatable.dart';

class MessageDto extends Equatable {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final DateTime dateTime;

  const MessageDto({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.dateTime,
  });

  MessageDto.fromJson({
    required String messageId,
    required Map<String, dynamic>? json,
  }) : this(
          id: messageId,
          chatId: json?[_chatIdField],
          senderId: json?[_senderIdField],
          content: json?[_contentField],
          dateTime: DateTime.fromMillisecondsSinceEpoch(json?[_timestampField]),
        );

  @override
  List<Object?> get props => [id, chatId, senderId, content, dateTime];

  Map<String, dynamic> toJson() => {
        _chatIdField: chatId,
        _senderIdField: senderId,
        _contentField: content,
        _timestampField: dateTime.millisecondsSinceEpoch,
      };
}

const String _chatIdField = 'chatId';
const String _senderIdField = 'senderId';
const String _contentField = 'content';
const String _timestampField = 'timestamp';
