import 'entity.dart';

enum InvitationStatus { pending, accepted, discarded }

class Invitation extends Entity {
  final String senderId;
  final String receiverId;
  final InvitationStatus status;

  const Invitation({
    required super.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        status,
      ];
}
