import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/profile/coach/profile_coach_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';

import '../../../../creators/person_creator.dart';

void main() {
  late ProfileCoachState state;

  setUp(
    () => state = const ProfileCoachState(status: BlocStatusInitial()),
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedStatus);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with receivedCoachingRequests',
    () {
      final List<CoachingRequestInfo> expectedReceivedCoachingRequests = [
        CoachingRequestInfo(id: 'r1', sender: createPerson(id: 'u1')),
      ];

      state = state.copyWith(
        receivedCoachingRequests: expectedReceivedCoachingRequests,
      );
      final state2 = state.copyWith();

      expect(state.receivedCoachingRequests, expectedReceivedCoachingRequests);
      expect(state2.receivedCoachingRequests, expectedReceivedCoachingRequests);
    },
  );

  test(
    'copy with coach',
    () {
      final Person expectedCoach = createPerson(id: 'c1');

      state = state.copyWith(coach: expectedCoach);
      final state2 = state.copyWith();

      expect(state.coach, expectedCoach);
      expect(state2.coach, expectedCoach);
    },
  );
}
