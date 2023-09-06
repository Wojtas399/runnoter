import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/cubit/profile/coach/profile_coach_cubit.dart';
import 'package:runnoter/domain/entity/person.dart';

import '../../../../creators/person_creator.dart';

void main() {
  late ProfileCoachState state;

  setUp(
    () => state = const ProfileCoachState(status: BlocStatusInitial()),
  );

  test(
    'does coach exist, '
    'coach id, full name and email are not null, '
    'should be true',
    () {
      state = state.copyWith(
        coachId: 'c1',
        coachFullName: 'full name',
        coachEmail: 'email',
      );

      expect(state.doesCoachExist, true);
    },
  );

  test(
    'does coach exist, '
    'coach id is null, '
    'should be false',
    () {
      state = state.copyWith(
        coachFullName: 'full name',
        coachEmail: 'email',
      );

      expect(state.doesCoachExist, false);
    },
  );

  test(
    'does coach exist, '
    'coach full name is null, '
    'should be false',
    () {
      state = state.copyWith(
        coachId: 'c1',
        coachEmail: 'email',
      );

      expect(state.doesCoachExist, false);
    },
  );

  test(
    'does coach exist, '
    'coach email is null, '
    'should be false',
    () {
      state = state.copyWith(
        coachId: 'c1',
        coachFullName: 'full name',
      );

      expect(state.doesCoachExist, false);
    },
  );

  test(
    'copy with status, '
    'should set complete status if new value is null',
    () {
      const BlocStatus expected = BlocStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const BlocStatusComplete());
    },
  );

  test(
    'copy with sentRequests, '
    'should copy current value if new value is null',
    () {
      final List<CoachingRequestShort> expected = [
        CoachingRequestShort(
          id: 'r1',
          personToDisplay: createPerson(id: 'u1'),
        ),
      ];

      state = state.copyWith(sentRequests: expected);
      final state2 = state.copyWith();

      expect(state.sentRequests, expected);
      expect(state2.sentRequests, expected);
    },
  );

  test(
    'copy with receivedRequests, '
    'should copy current value if new value is null',
    () {
      final List<CoachingRequestShort> expected = [
        CoachingRequestShort(
          id: 'r1',
          personToDisplay: createPerson(id: 'u1'),
        ),
      ];

      state = state.copyWith(receivedRequests: expected);
      final state2 = state.copyWith();

      expect(state.receivedRequests, expected);
      expect(state2.receivedRequests, expected);
    },
  );

  test(
    'copy with coach, '
    'should copy current value if new value is null',
    () {
      final Person expected = createPerson(id: 'c1');

      state = state.copyWith(coach: expected);
      final state2 = state.copyWith();

      expect(state.coach, expected);
      expect(state2.coach, expected);
    },
  );

  test(
    'copy with coachId, '
    'should copy current value if new value is null',
    () {
      const String expected = 'c1';

      state = state.copyWith(coachId: expected);
      final state2 = state.copyWith();

      expect(state.coachId, expected);
      expect(state2.coachId, expected);
    },
  );

  test(
    'copy with coachFullName, '
    'should copy current value if new value is null',
    () {
      const String expected = 'coach full name';

      state = state.copyWith(coachFullName: expected);
      final state2 = state.copyWith();

      expect(state.coachFullName, expected);
      expect(state2.coachFullName, expected);
    },
  );

  test(
    'copy with coachEmail, '
    'should copy current value if new value is null',
    () {
      const String expected = 'email@example.com';

      state = state.copyWith(coachEmail: expected);
      final state2 = state.copyWith();

      expect(state.coachEmail, expected);
      expect(state2.coachEmail, expected);
    },
  );

  test(
    'copy with deletedCoachParams, '
    'should set coach id, full name and email as null if set to true',
    () {
      const String coachId = 'c1';
      const String coachFullName = 'full name';
      const String coachEmail = 'email';

      state = state.copyWith(
        coachId: coachId,
        coachFullName: coachFullName,
        coachEmail: coachEmail,
      );
      final state2 = state.copyWith(deletedCoachParams: true);

      expect(state.coachId, coachId);
      expect(state.coachFullName, coachFullName);
      expect(state.coachEmail, coachEmail);
      expect(state2.coachId, null);
      expect(state2.coachFullName, null);
      expect(state2.coachEmail, null);
    },
  );

  test(
    'copy with idOfChatWithCoach, '
    'should copy current value if new value is null',
    () {
      const String expected = 'c1';

      state = state.copyWith(idOfChatWithCoach: expected);
      final state2 = state.copyWith();

      expect(state.idOfChatWithCoach, expected);
      expect(state2.idOfChatWithCoach, expected);
    },
  );
}
