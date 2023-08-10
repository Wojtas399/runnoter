import 'package:equatable/equatable.dart';

//TODO: Change the name to coachingRequest
enum InvitationStatus { pending, accepted, discarded }

class Invitation extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final InvitationStatus status;

  const Invitation({
    required this.id,
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
