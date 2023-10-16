import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';
import 'package:runnoter/data/mapper/coaching_request_direction_mapper.dart';

void main() {
  test(
    'map coaching request direction from dto, '
    'dto CoachingRequestDirection.clientToCoach should be mapped to domain CoachingRequestDirection.clientToCoach',
    () {
      const firebase.CoachingRequestDirection dtoDirection =
          firebase.CoachingRequestDirection.clientToCoach;
      const CoachingRequestDirection expectedDirection =
          CoachingRequestDirection.clientToCoach;

      final CoachingRequestDirection direction =
          mapCoachingRequestDirectionFromDto(dtoDirection);

      expect(direction, expectedDirection);
    },
  );

  test(
    'map coaching request direction from dto, '
    'dto CoachingRequestDirection.coachToClient should be mapped to domain CoachingRequestDirection.coachToClient',
    () {
      const firebase.CoachingRequestDirection dtoDirection =
          firebase.CoachingRequestDirection.coachToClient;
      const CoachingRequestDirection expectedDirection =
          CoachingRequestDirection.coachToClient;

      final CoachingRequestDirection direction =
          mapCoachingRequestDirectionFromDto(dtoDirection);

      expect(direction, expectedDirection);
    },
  );

  test(
    'map coaching request direction to dto, '
    'domain CoachingRequestDirection.clientToCoach should be mapped to dto CoachingRequestDirection.clientToCoach',
    () {
      const CoachingRequestDirection direction =
          CoachingRequestDirection.clientToCoach;
      const firebase.CoachingRequestDirection expectedDtoDirection =
          firebase.CoachingRequestDirection.clientToCoach;

      final firebase.CoachingRequestDirection dtoDirection =
          mapCoachingRequestDirectionToDto(direction);

      expect(dtoDirection, expectedDtoDirection);
    },
  );

  test(
    'map coaching request direction to dto, '
    'domain CoachingRequestDirection.coachToClient should be mapped to dto CoachingRequestDirection.coachToClient',
    () {
      const CoachingRequestDirection direction =
          CoachingRequestDirection.coachToClient;
      const firebase.CoachingRequestDirection expectedDtoDirection =
          firebase.CoachingRequestDirection.coachToClient;

      final firebase.CoachingRequestDirection dtoDirection =
          mapCoachingRequestDirectionToDto(direction);

      expect(dtoDirection, expectedDtoDirection);
    },
  );
}
