import 'entity.dart';

class Chat extends Entity {
  final String user1Id;
  final String user2Id;

  const Chat({
    required super.id,
    required this.user1Id,
    required this.user2Id,
  });

  @override
  List<Object?> get props => [id, user1Id, user2Id];
}
