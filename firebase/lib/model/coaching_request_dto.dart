import 'package:equatable/equatable.dart';

import '../mapper/coaching_request_direction_mapper.dart';

enum CoachingRequestDirection { clientToCoach, coachToClient }

class CoachingRequestDto extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final CoachingRequestDirection direction;
  final bool isAccepted;

  const CoachingRequestDto({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.direction,
    required this.isAccepted,
  }) : assert(senderId != receiverId);

  @override
  List<Object?> get props => [id, senderId, receiverId, direction, isAccepted];

  CoachingRequestDto.fromJson({
    required String coachingRequestId,
    required Map<String, dynamic>? json,
  }) : this(
          id: coachingRequestId,
          senderId: json?[senderIdField],
          receiverId: json?[receiverIdField],
          direction: mapCoachingRequestDirectionFromString(
            json?[directionField],
          ),
          isAccepted: json?[isAcceptedField],
        );

  Map<String, dynamic> toJson() => {
        senderIdField: senderId,
        receiverIdField: receiverId,
        directionField: mapCoachingRequestDirectionToString(direction),
        isAcceptedField: isAccepted,
      };
}

const String senderIdField = 'senderId';
const String receiverIdField = 'receiverId';
const String directionField = 'direction';
const String isAcceptedField = 'isAccepted';
