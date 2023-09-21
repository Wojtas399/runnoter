import 'entity.dart';

class Chat extends Entity {
  final String user1Id;
  final String user2Id;
  final bool isUser1Typing;
  final bool isUser2Typing;

  const Chat({
    required super.id,
    required this.user1Id,
    required this.user2Id,
    required this.isUser1Typing,
    required this.isUser2Typing,
  }) : assert(user1Id != user2Id);

  @override
  List<Object?> get props => [
        id,
        user1Id,
        user2Id,
        isUser1Typing,
        isUser2Typing,
      ];
}
