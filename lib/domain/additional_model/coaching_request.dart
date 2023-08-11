import 'package:equatable/equatable.dart';

class CoachingRequest extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final bool isAccepted;

  const CoachingRequest({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.isAccepted,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        isAccepted,
      ];
}
