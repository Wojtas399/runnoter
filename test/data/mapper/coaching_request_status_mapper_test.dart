import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/coaching_request_status_mapper.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';

void main() {
  test(
    'map coaching request status from dto, '
    'dto InvitationStatus.pending should be mapped to domain CoachingRequestStatus.pending',
    () {
      const firebase.InvitationStatus dtoStatus =
          firebase.InvitationStatus.pending;
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.pending;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status from dto, '
    'dto InvitationStatus.accepted should be mapped to domain CoachingRequestStatus.accepted',
    () {
      const firebase.InvitationStatus dtoStatus =
          firebase.InvitationStatus.accepted;
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.accepted;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status from dto, '
    'dto InvitationStatus.discarded should be mapped to domain CoachingRequestStatus.declined',
    () {
      const firebase.InvitationStatus dtoStatus =
          firebase.InvitationStatus.discarded;
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.declined;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status to dto, '
    'domain InvitationStatus.pending should be mapped to dto InvitationStatus.pending',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.pending;
      const firebase.InvitationStatus expectedDtoStatus =
          firebase.InvitationStatus.pending;

      final firebase.InvitationStatus dtoStatus =
          mapCoachingRequestStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map coaching request status to dto, '
    'domain InvitationStatus.accepted should be mapped to dto InvitationStatus.accepted',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.accepted;
      const firebase.InvitationStatus expectedDtoStatus =
          firebase.InvitationStatus.accepted;

      final firebase.InvitationStatus dtoStatus =
          mapCoachingRequestStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map coaching request status to dto, '
    'domain InvitationStatus.declined should be mapped to dto InvitationStatus.discarded',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.declined;
      const firebase.InvitationStatus expectedDtoStatus =
          firebase.InvitationStatus.discarded;

      final firebase.InvitationStatus dtoStatus =
          mapCoachingRequestStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );
}
