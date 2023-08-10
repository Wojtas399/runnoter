import 'package:equatable/equatable.dart';

import '../mapper/invitation_status_mapper.dart';

enum InvitationStatus { pending, accepted, discarded }

//TODO: Change the name to CoachingRequestDto
class InvitationDto extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final InvitationStatus status;

  const InvitationDto({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.status,
  }) : assert(senderId != receiverId);

  @override
  List<Object?> get props => [id, senderId, receiverId, status];

  InvitationDto.fromJson({
    required String invitationId,
    required Map<String, dynamic>? json,
  }) : this(
          id: invitationId,
          senderId: json?[senderIdField],
          receiverId: json?[receiverIdField],
          status: mapInvitationStatusFromString(json?[invitationStatusField]),
        );

  Map<String, dynamic> toJson() => {
        senderIdField: senderId,
        receiverIdField: receiverId,
        invitationStatusField: mapInvitationStatusToString(status),
      };
}

const String senderIdField = 'senderId';
const String receiverIdField = 'receiverId';
const String invitationStatusField = 'status';
