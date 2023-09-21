import 'package:equatable/equatable.dart';

class ChatDto extends Equatable {
  final String id;
  final String user1Id;
  final String user2Id;
  final bool isUser1Typing;
  final bool isUser2Typing;

  const ChatDto({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.isUser1Typing,
    required this.isUser2Typing,
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
        );

  @override
  List<Object?> get props => [id, user1Id, user2Id];

  Map<String, dynamic> toJson() => {
        user1IdField: user1Id,
        user2IdField: user2Id,
        _isUser1TypingField: isUser1Typing,
        _isUser2TypingField: isUser2Typing,
      };
}

const String user1IdField = 'user1Id';
const String user2IdField = 'user2Id';
const String _isUser1TypingField = 'isUser1Typing';
const String _isUser2TypingField = 'isUser2Typing';
