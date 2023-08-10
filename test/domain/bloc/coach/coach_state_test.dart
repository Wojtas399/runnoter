import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/bloc/coach/coach_state.dart';

import '../../../creators/user_basic_info_creator.dart';

void main() {
  late CoachState state;

  setUp(
    () => state = const CoachState(status: BlocStatusInitial()),
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
    'copy with coachStatus',
    () {
      const CoachStatus expectedCoachStatus = CoachStatus.waitingForApproval;

      state = state.copyWith(coachStatus: expectedCoachStatus);
      final state2 = state.copyWith();

      expect(state.coachStatus, expectedCoachStatus);
      expect(state2.coachStatus, expectedCoachStatus);
    },
  );

  test(
    'copy with coach',
    () {
      final UserBasicInfo expectedCoach = createUserBasicInfo(id: 'c1');

      state = state.copyWith(coach: expectedCoach);
      final state2 = state.copyWith();

      expect(state.coach, expectedCoach);
      expect(state2.coach, expectedCoach);
    },
  );
}
