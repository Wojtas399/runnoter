import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/settings.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/person.dart';
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
    'copy with account type',
    () {
      const AccountType expectedAccountType = AccountType.coach;

      state = state.copyWith(accountType: expectedAccountType);
      final state2 = state.copyWith();

      expect(state.accountType, expectedAccountType);
      expect(state2.accountType, expectedAccountType);
    },
  );

  test(
    'copy with logged user name',
    () {
      const String expectedLoggedUserName = 'name';

      state = state.copyWith(loggedUserName: expectedLoggedUserName);
      final state2 = state.copyWith();

      expect(state.loggedUserName, expectedLoggedUserName);
      expect(state2.loggedUserName, expectedLoggedUserName);
    },
  );

  test(
    'copy with app settings',
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
    'copy with new clients',
    () {
      final List<Person> expectedNewClients = [
        createPerson(id: 'u1'),
        createPerson(id: 'u2'),
      ];

      state = state.copyWith(newClients: expectedNewClients);
      final state2 = state.copyWith();

      expect(state.newClients, expectedNewClients);
      expect(state2.newClients, expectedNewClients);
    },
  );
}
