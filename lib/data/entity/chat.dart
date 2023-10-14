import '../../domain/entity/entity.dart';

class Chat extends Entity {
  final String user1Id;
  final String user2Id;
  final DateTime? user1LastTypingDateTime;
  final DateTime? user2LastTypingDateTime;

  const Chat({
    required super.id,
    required this.user1Id,
    required this.user2Id,
    this.user1LastTypingDateTime,
    this.user2LastTypingDateTime,
  }) : assert(user1Id != user2Id);

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        user1LastTypingDateTime,
        user2LastTypingDateTime,
      ];
}
