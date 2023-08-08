import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/invitation_status_mapper.dart';
import 'package:runnoter/domain/entity/invitation.dart';

void main() {
  test(
    'map invitation status from dto, '
    'dto InvitationStatus.pending should be mapped to domain InvitationStatus.pending',
    () {
      const firebase.InvitationStatus dtoStatus =
          firebase.InvitationStatus.pending;
      const InvitationStatus expectedStatus = InvitationStatus.pending;

      final InvitationStatus status = mapInvitationStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map invitation status from dto, '
    'dto InvitationStatus.accepted should be mapped to domain InvitationStatus.accepted',
    () {
      const firebase.InvitationStatus dtoStatus =
          firebase.InvitationStatus.accepted;
      const InvitationStatus expectedStatus = InvitationStatus.accepted;

      final InvitationStatus status = mapInvitationStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map invitation status from dto, '
    'dto InvitationStatus.discarded should be mapped to domain InvitationStatus.discarded',
    () {
      const firebase.InvitationStatus dtoStatus =
          firebase.InvitationStatus.discarded;
      const InvitationStatus expectedStatus = InvitationStatus.discarded;

      final InvitationStatus status = mapInvitationStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map invitation status to dto, '
    'domain InvitationStatus.pending should be mapped to dto InvitationStatus.pending',
    () {
      const InvitationStatus status = InvitationStatus.pending;
      const firebase.InvitationStatus expectedDtoStatus =
          firebase.InvitationStatus.pending;

      final firebase.InvitationStatus dtoStatus =
          mapInvitationStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map invitation status to dto, '
    'domain InvitationStatus.accepted should be mapped to dto InvitationStatus.accepted',
    () {
      const InvitationStatus status = InvitationStatus.accepted;
      const firebase.InvitationStatus expectedDtoStatus =
          firebase.InvitationStatus.accepted;

      final firebase.InvitationStatus dtoStatus =
          mapInvitationStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map invitation status to dto, '
    'domain InvitationStatus.discarded should be mapped to dto InvitationStatus.discarded',
    () {
      const InvitationStatus status = InvitationStatus.discarded;
      const firebase.InvitationStatus expectedDtoStatus =
          firebase.InvitationStatus.discarded;

      final firebase.InvitationStatus dtoStatus =
          mapInvitationStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );
}
