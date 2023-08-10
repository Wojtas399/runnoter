import 'package:equatable/equatable.dart';

enum CoachingRequestStatus { pending, accepted, declined }

class CoachingRequest extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final CoachingRequestStatus status;

  const CoachingRequest({
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
