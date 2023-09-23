import 'package:equatable/equatable.dart';

class ChatDto extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final bool isUser1Typing;
  final bool isUser2Typing;
  final DateTime? user1LastTypingDateTime;
  final DateTime? user2LastTypingDateTime;

  const ChatDto({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.isUser1Typing,
    required this.isUser2Typing,
    this.user1LastTypingDateTime,
    this.user2LastTypingDateTime,
  }) : assert(user1Id != user2Id);

  ChatDto.fromJson({
    required String chatId,
    required Map<String, dynamic>? json,
  }) : this(
          id: chatId,
          user1Id: json?[user1IdField],
          user2Id: json?[user2IdField],
          isUser1Typing: json?[_isUser1TypingField],
          isUser2Typing: json?[_isUser2TypingField],
          user1LastTypingDateTime: DateTime.fromMillisecondsSinceEpoch(
            json?[_user1LastTypingTimestampField],
          ),
          user2LastTypingDateTime: DateTime.fromMillisecondsSinceEpoch(
            json?[_user2LastTypingTimestampField],
          ),
        );

  @override
  List<Object?> get props => [id, user1Id, user2Id];

  Map<String, dynamic> toJson() => {
        user1IdField: user1Id,
        user2IdField: user2Id,
        _isUser1TypingField: isUser1Typing,
        _isUser2TypingField: isUser2Typing,
        _user1LastTypingTimestampField:
            user1LastTypingDateTime?.millisecondsSinceEpoch,
        _user2LastTypingTimestampField:
            user2LastTypingDateTime?.millisecondsSinceEpoch,
      };
}

Map<String, dynamic> createChatJsonToUpdate({
  bool? isUser1Typing,
  bool? isUser2Typing,
  DateTime? user1LastTypingDateTime,
  DateTime? user2LastTypingDateTime,
}) =>
    {
      if (isUser1Typing != null) _isUser1TypingField: isUser1Typing,
      if (isUser2Typing != null) _isUser2TypingField: isUser2Typing,
      if (user1LastTypingDateTime != null)
        _user1LastTypingTimestampField:
            user1LastTypingDateTime.millisecondsSinceEpoch,
      if (user2LastTypingDateTime != null)
        _user2LastTypingTimestampField:
            user2LastTypingDateTime.millisecondsSinceEpoch,
    };

const String user1IdField = 'user1Id';
const String user2IdField = 'user2Id';
const String _isUser1TypingField = 'isUser1Typing';
const String _isUser2TypingField = 'isUser2Typing';
const String _user1LastTypingTimestampField = 'user1LastTypingTimestamp';
const String _user2LastTypingTimestampField = 'user2LastTypingTimestamp';
