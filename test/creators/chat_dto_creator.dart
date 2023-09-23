import 'package:firebase/firebase.dart';

ChatDto createChatDto({
  String id = '',
  String user1Id = 'u1',
  String user2Id = 'u2',
  DateTime? user1LastTypingDateTime,
  DateTime? user2LastTypingDateTime,
}) =>
    ChatDto(
      id: id,
      user1Id: user1Id,
      user2Id: user2Id,
      user1LastTypingDateTime: user1LastTypingDateTime,
      user2LastTypingDateTime: user2LastTypingDateTime,
    );
