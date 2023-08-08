import 'package:firebase/mapper/invitation_status_mapper.dart';
import 'package:firebase/model/invitation_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map invitation status from string, '
    'pending string should be mapped to InvitationStatus.pending',
    () {
      const String statusStr = 'pending';
      const InvitationStatus expectedStatus = InvitationStatus.pending;

      final InvitationStatus status = mapInvitationStatusFromString(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map invitation status from string, '
    'accepted string should be mapped to InvitationStatus.accepted',
    () {
      const String statusStr = 'accepted';
      const InvitationStatus expectedStatus = InvitationStatus.accepted;

      final InvitationStatus status = mapInvitationStatusFromString(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map invitation status from string, '
    'discarded string should be mapped to InvitationStatus.discarded',
    () {
      const String statusStr = 'discarded';
      const InvitationStatus expectedStatus = InvitationStatus.discarded;

      final InvitationStatus status = mapInvitationStatusFromString(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map invitation status to string, '
    'InvitationStatus.pending should be mapped to pending string',
    () {
      const InvitationStatus status = InvitationStatus.pending;
      const String expectedStatusStr = 'pending';

      final String statusStr = mapInvitationStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );

  test(
    'map invitation status to string, '
    'InvitationStatus.accepted should be mapped to accepted string',
    () {
      const InvitationStatus status = InvitationStatus.accepted;
      const String expectedStatusStr = 'accepted';

      final String statusStr = mapInvitationStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );

  test(
    'map invitation status to string, '
    'InvitationStatus.discarded should be mapped to discarded string',
    () {
      const InvitationStatus status = InvitationStatus.discarded;
      const String expectedStatusStr = 'discarded';

      final String statusStr = mapInvitationStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );
}
