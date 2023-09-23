import 'package:equatable/equatable.dart';

class ChatDto extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final DateTime? user1LastTypingDateTime;
  final DateTime? user2LastTypingDateTime;

  const ChatDto({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    this.user1LastTypingDateTime,
    this.user2LastTypingDateTime,
  }) : assert(user1Id != user2Id);

  factory ChatDto.fromJson({
    required String chatId,
    required Map<String, dynamic>? json,
  }) {
    final int? user1LastTypingTimestamp = json?[_user1LastTypingTimestampField];
    final int? user2LastTypingTimestamp = json?[_user2LastTypingTimestampField];
    return ChatDto(
      id: chatId,
      user1Id: json?[user1IdField],
      user2Id: json?[user2IdField],
      user1LastTypingDateTime: user1LastTypingTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(user1LastTypingTimestamp)
          : null,
      user2LastTypingDateTime: user2LastTypingTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(user2LastTypingTimestamp)
          : null,
    );
  }

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        user1LastTypingDateTime,
        user2LastTypingDateTime,
      ];

  Map<String, dynamic> toJson() => {
        user1IdField: user1Id,
        user2IdField: user2Id,
        _user1LastTypingTimestampField:
            user1LastTypingDateTime?.millisecondsSinceEpoch,
        _user2LastTypingTimestampField:
            user2LastTypingDateTime?.millisecondsSinceEpoch,
      };
}

Map<String, dynamic> createChatJsonToUpdate({
  DateTime? user1LastTypingDateTime,
  DateTime? user2LastTypingDateTime,
}) =>
    {
      if (user1LastTypingDateTime != null)
        _user1LastTypingTimestampField:
            user1LastTypingDateTime.millisecondsSinceEpoch,
      if (user2LastTypingDateTime != null)
        _user2LastTypingTimestampField:
            user2LastTypingDateTime.millisecondsSinceEpoch,
    };

const String user1IdField = 'user1Id';
const String user2IdField = 'user2Id';
const String _user1LastTypingTimestampField = 'user1LastTypingTimestamp';
const String _user2LastTypingTimestampField = 'user2LastTypingTimestamp';
