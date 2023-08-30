import 'package:firebase/mapper/coaching_request_direction_mapper.dart';
import 'package:firebase/model/coaching_request_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map coaching request direction from string, '
    'clientToCoach string should be mapped to CoachingRequestDirection.clientToCoach type',
    () {
      const String directionStr = 'clientToCoach';
      const CoachingRequestDirection expectedDirection =
          CoachingRequestDirection.clientToCoach;

      final CoachingRequestDirection direction =
          mapCoachingRequestDirectionFromString(directionStr);

      expect(direction, expectedDirection);
    },
  );

  test(
    'map coaching request direction from string, '
    'coachToClient string should be mapped to CoachingRequestDirection.coachToClient type',
    () {
      const String directionStr = 'coachToClient';
      const CoachingRequestDirection expectedDirection =
          CoachingRequestDirection.coachToClient;

      final CoachingRequestDirection direction =
          mapCoachingRequestDirectionFromString(directionStr);

      expect(direction, expectedDirection);
    },
  );

  test(
    'map coaching request direction to string, '
    'CoachingRequestDirection.clientToCoach should be mapped to clientToCoach string',
    () {
      const CoachingRequestDirection direction =
          CoachingRequestDirection.clientToCoach;
      const String expectedDirectionStr = 'clientToCoach';

      final String directionStr =
          mapCoachingRequestDirectionToString(direction);

      expect(directionStr, expectedDirectionStr);
    },
  );

  test(
    'map coaching request direction to string, '
    'CoachingRequestDirection.coachToClient should be mapped to coachToClient string',
    () {
      const CoachingRequestDirection direction =
          CoachingRequestDirection.coachToClient;
      const String expectedDirectionStr = 'coachToClient';

      final String directionStr =
          mapCoachingRequestDirectionToString(direction);

      expect(directionStr, expectedDirectionStr);
    },
  );
}
