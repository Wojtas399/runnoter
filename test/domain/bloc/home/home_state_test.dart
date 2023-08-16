import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request_short.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';

import '../../../creators/person_creator.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(
      status: BlocStatusInitial(),
    );
  });

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
    'copy with accountType',
    () {
      const AccountType expectedAccountType = AccountType.coach;

      state = state.copyWith(accountType: expectedAccountType);
      final state2 = state.copyWith();

      expect(state.accountType, expectedAccountType);
      expect(state2.accountType, expectedAccountType);
    },
  );

  test(
    'copy with loggedUserName',
    () {
      const String expectedLoggedUserName = 'name';

      state = state.copyWith(loggedUserName: expectedLoggedUserName);
      final state2 = state.copyWith();

      expect(state.loggedUserName, expectedLoggedUserName);
      expect(state2.loggedUserName, expectedLoggedUserName);
    },
  );

  test(
    'copy with appSettings',
    () {
      const Settings expectedSettings = Settings(
        themeMode: ThemeMode.dark,
        language: Language.polish,
        distanceUnit: DistanceUnit.miles,
        paceUnit: PaceUnit.milesPerHour,
      );

      state = state.copyWith(appSettings: expectedSettings);
      final state2 = state.copyWith();

      expect(state.appSettings, expectedSettings);
      expect(state2.appSettings, expectedSettings);
    },
  );

  test(
    'copy with acceptedClientRequests',
    () {
      final List<CoachingRequestShort> expectedAcceptedClientRequests = [
        CoachingRequestShort(id: 'r1', personToDisplay: createPerson(id: 'u1')),
        CoachingRequestShort(id: 'r2', personToDisplay: createPerson(id: 'u2')),
      ];

      state = state.copyWith(
        acceptedClientRequests: expectedAcceptedClientRequests,
      );
      final state2 = state.copyWith();

      expect(state.acceptedClientRequests, expectedAcceptedClientRequests);
      expect(state2.acceptedClientRequests, const []);
    },
  );

  test(
    'copy with acceptedCoachRequest',
    () {
      final CoachingRequestShort expectedAcceptedCoachRequest =
          CoachingRequestShort(
        id: 'r1',
        personToDisplay: createPerson(id: 'p1'),
      );

      state = state.copyWith(
        acceptedCoachRequest: expectedAcceptedCoachRequest,
      );
      final state2 = state.copyWith();

      expect(state.acceptedCoachRequest, expectedAcceptedCoachRequest);
      expect(state2.acceptedCoachRequest, null);
    },
  );
}
