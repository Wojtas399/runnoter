import 'package:equatable/equatable.dart';

import '../mapper/coatching_request_status_mapper.dart';

enum CoachingRequestStatus { pending, accepted, declined }

class CoachingRequestDto extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final CoachingRequestStatus status;

  const CoachingRequestDto({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  }) : assert(senderId != receiverId);

  @override
  List<Object?> get props => [id, senderId, receiverId, status];

  CoachingRequestDto.fromJson({
    required String coachingRequestId,
    required Map<String, dynamic>? json,
  }) : this(
          id: coachingRequestId,
          senderId: json?[senderIdField],
          receiverId: json?[receiverIdField],
          status: mapCoachingRequestStatusFromString(
            json?[coachingRequestStatusField],
          ),
        );

  Map<String, dynamic> toJson() => {
        senderIdField: senderId,
        receiverIdField: receiverId,
        coachingRequestStatusField: mapCoachingRequestStatusToString(status),
      };
}

const String senderIdField = 'senderId';
const String receiverIdField = 'receiverId';
const String coachingRequestStatusField = 'status';
