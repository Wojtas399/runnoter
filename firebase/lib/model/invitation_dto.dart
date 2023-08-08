import 'package:equatable/equatable.dart';

import '../mapper/invitation_status_mapper.dart';

enum InvitationStatus { pending, accepted, discarded }

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
          senderId: json?[_senderIdField],
          receiverId: json?[_receiverIdField],
          status: mapInvitationStatusFromString(json?[invitationStatusField]),
        );

  Map<String, dynamic> toJson() => {
        _senderIdField: senderId,
        _receiverIdField: receiverId,
        invitationStatusField: mapInvitationStatusToString(status),
      };
}

const String _senderIdField = 'senderId';
const String _receiverIdField = 'receiverId';
const String invitationStatusField = 'status';
