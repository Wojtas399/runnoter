import 'package:runnoter/domain/additional_model/invitation.dart';

Invitation createInvitation({
  String id = '',
  String senderId = '',
  String receiverId = '',
  InvitationStatus status = InvitationStatus.pending,
}) =>
    Invitation(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      status: status,
    );
