import 'package:runnoter/data/model/chat.dart';

Chat createChat({
  String id = '',
  String user1Id = 'u1',
  String user2Id = 'u2',
  DateTime? user1LastTypingDateTime,
  DateTime? user2LastTypingDateTime,
}) =>
    Chat(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      user1LastTypingDateTime: user1LastTypingDateTime,
      user2LastTypingDateTime: user2LastTypingDateTime,
    );
