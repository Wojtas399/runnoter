import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
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
    'copy with sentRequests',
    () {
      final List<CoachingRequestShort> expectedSentRequests = [
        CoachingRequestShort(
          id: 'r1',
          personToDisplay: createPerson(id: 'u1'),
        ),
      ];

      state = state.copyWith(sentRequests: expectedSentRequests);
      final state2 = state.copyWith();

      expect(state.sentRequests, expectedSentRequests);
      expect(state2.sentRequests, expectedSentRequests);
    },
  );

  test(
    'copy with receivedRequests',
    () {
      final List<CoachingRequestShort> expectedReceivedRequests = [
        CoachingRequestShort(
          id: 'r1',
          personToDisplay: createPerson(id: 'u1'),
        ),
      ];

      state = state.copyWith(receivedRequests: expectedReceivedRequests);
      final state2 = state.copyWith();

      expect(state.receivedRequests, expectedReceivedRequests);
      expect(state2.receivedRequests, expectedReceivedRequests);
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

  test(
    'copy with setCoachAsNull',
    () {
      final Person coach = createPerson(id: 'c1');

      state = state.copyWith(coach: coach);
      final state2 = state.copyWith(setCoachAsNull: true);

      expect(state.coach, coach);
      expect(state2.coach, null);
    },
  );
}
