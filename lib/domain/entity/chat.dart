import 'entity.dart';
import 'message.dart';

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
