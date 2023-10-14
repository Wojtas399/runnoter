import 'package:equatable/equatable.dart';

enum CoachingRequestDirection { clientToCoach, coachToClient }

class CoachingRequest extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final CoachingRequestDirection direction;
  final bool isAccepted;

  const CoachingRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.direction,
    required this.isAccepted,
  });

  @override
  List<Object?> get props => [id, senderId, receiverId, direction, isAccepted];
}
