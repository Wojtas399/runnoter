import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/invitation_mapper.dart';
import 'package:runnoter/domain/additional_model/invitation.dart';

void main() {
  const String invitationId = 'i1';
  const String senderId = 'u1';
  const String receiverId = 'u2';
  const firebase.InvitationStatus dtoStatus = firebase.InvitationStatus.pending;
  const InvitationStatus status = InvitationStatus.pending;

  test(
    'map invitation from dto, '
    'should map dto invitation model to domain invitation model',
    () {
      const firebase.InvitationDto invitationDto = firebase.InvitationDto(
        id: invitationId,
        senderId: senderId,
        receiverId: receiverId,
        status: dtoStatus,
      );
      const Invitation expectedInvitation = Invitation(
        id: invitationId,
        senderId: senderId,
        receiverId: receiverId,
        status: status,
      );

      final Invitation invitation = mapInvitationFromDto(invitationDto);

      expect(invitation, expectedInvitation);
    },
  );
}
