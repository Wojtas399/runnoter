import 'package:equatable/equatable.dart';

import 'entity.dart';

class Chat extends Entity {
  final String user1Id;
  final String user2Id;
  final List<Message> messages;

  const Chat({
    required super.id,
    required this.user1Id,
    required this.user2Id,
    required this.messages,
  });

  @override
  List<Object?> get props => [id, user1Id, user2Id, messages];
}

class Message extends Equatable {
  final String id;
  final String senderId;
  final String content;
  final DateTime dateTime;

  const Message({
    required this.id,
    required this.senderId,
    required this.content,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [id, senderId, content, dateTime];
}
