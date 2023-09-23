import 'package:runnoter/domain/entity/chat.dart';

Chat createChat({
  String id = '',
  String user1Id = 'u1',
  String user2Id = 'u2',
  bool isUser1Typing = false,
  bool isUser2Typing = false,
  DateTime? user1LastTypingDateTime,
  DateTime? user2LastTypingDateTime,
}) =>
    Chat(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      isUser1Typing: isUser1Typing,
      isUser2Typing: isUser2Typing,
      user1LastTypingDateTime: user1LastTypingDateTime,
      user2LastTypingDateTime: user2LastTypingDateTime,
    );
