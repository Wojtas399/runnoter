import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/invitation.dart';
import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/bloc/coach/coach_bloc.dart';

import '../../../creators/invitation_creator.dart';
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
    'copy with invitations',
    () {
      final List<Invitation> expectedInvitations = [createInvitation(id: 'i1')];

      state = state.copyWith(invitations: expectedInvitations);
      final state2 = state.copyWith();

      expect(state.invitations, expectedInvitations);
      expect(state2.invitations, expectedInvitations);
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
