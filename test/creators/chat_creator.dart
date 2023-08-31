import 'package:runnoter/domain/entity/chat.dart';

Chat createChat({
  String id = '',
  String user1Id = 'u1',
  String user2Id = 'u2',
}) =>
    Chat(id: id, user1Id: user1Id, user2Id: user2Id);