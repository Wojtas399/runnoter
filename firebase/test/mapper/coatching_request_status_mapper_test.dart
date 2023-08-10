import 'package:firebase/mapper/coatching_request_status_mapper.dart';
import 'package:firebase/model/coaching_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map coaching request status from string, '
    'pending string should be mapped to CoachingRequestStatus.pending',
    () {
      const String statusStr = 'pending';
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.pending;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromString(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status from string, '
    'accepted string should be mapped to CoachingRequestStatus.accepted',
    () {
      const String statusStr = 'accepted';
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.accepted;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromString(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status from string, '
    'declined string should be mapped to CoachingRequestStatus.declined',
    () {
      const String statusStr = 'declined';
      const CoachingRequestStatus expectedStatus =
          CoachingRequestStatus.declined;

      final CoachingRequestStatus status =
          mapCoachingRequestStatusFromString(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map coaching request status to string, '
    'CoachingRequestStatus.pending should be mapped to pending string',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.pending;
      const String expectedStatusStr = 'pending';

      final String statusStr = mapCoachingRequestStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );

  test(
    'map coaching request status to string, '
    'CoachingRequestStatus.accepted should be mapped to accepted string',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.accepted;
      const String expectedStatusStr = 'accepted';

      final String statusStr = mapCoachingRequestStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );

  test(
    'map coaching request status to string, '
    'CoachingRequestStatus.declined should be mapped to declined string',
    () {
      const CoachingRequestStatus status = CoachingRequestStatus.declined;
      const String expectedStatusStr = 'declined';

      final String statusStr = mapCoachingRequestStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );
}
