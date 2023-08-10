import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/coaching_request_status_mapper.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';

void main() {
  test(
    'map coaching request status from dto, '
    'dto CoachingRequestStatus.pending should be mapped to domain CoachingRequestStatus.pending',
    () {
      const firebase.CoachingRequestStatus dtoStatus =
          firebase.CoachingRequestStatus.pending;
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.pending;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status from dto, '
    'dto CoachingRequestStatus.accepted should be mapped to domain CoachingRequestStatus.accepted',
    () {
      const firebase.CoachingRequestStatus dtoStatus =
          firebase.CoachingRequestStatus.accepted;
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.accepted;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status from dto, '
    'dto CoachingRequestStatus.declined should be mapped to domain CoachingRequestStatus.declined',
    () {
      const firebase.CoachingRequestStatus dtoStatus =
          firebase.CoachingRequestStatus.declined;
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.declined;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromDto(dtoStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status to dto, '
    'domain CoachingRequestStatus.pending should be mapped to dto CoachingRequestStatus.pending',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.pending;
      const firebase.CoachingRequestStatus expectedDtoStatus =
          firebase.CoachingRequestStatus.pending;

      final firebase.CoachingRequestStatus dtoStatus =
          mapCoachingRequestStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map coaching request status to dto, '
    'domain CoachingRequestStatus.accepted should be mapped to dto CoachingRequestStatus.accepted',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.accepted;
      const firebase.CoachingRequestStatus expectedDtoStatus =
          firebase.CoachingRequestStatus.accepted;

      final firebase.CoachingRequestStatus dtoStatus =
          mapCoachingRequestStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );

  test(
    'map coaching request status to dto, '
    'domain CoachingRequestStatus.declined should be mapped to dto CoachingRequestStatus.declined',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.declined;
      const firebase.CoachingRequestStatus expectedDtoStatus =
          firebase.CoachingRequestStatus.declined;

      final firebase.CoachingRequestStatus dtoStatus =
          mapCoachingRequestStatusToDto(status);

      expect(dtoStatus, expectedDtoStatus);
    },
  );
}
