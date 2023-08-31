import 'package:firebase/firebase.dart';

ChatDto createChatDto({
  String id = '',
  String user1Id = 'u1',
  String user2Id = 'u2',
}) =>
    ChatDto(id: id, user1Id: user1Id, user2Id: user2Id);
