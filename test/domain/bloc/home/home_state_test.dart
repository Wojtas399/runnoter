import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/home/home_bloc.dart';
import 'package:runnoter/domain/entity/settings.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(
      status: BlocStatusInitial(),
      drawerPage: DrawerPage.home,
      bottomNavPage: BottomNavPage.currentWeek,
    );
  });

  test(
    'are all data loaded, '
    "logged user's name, surname and email aren't null and theme mode, language distance unit and pace unit also aren't null, "
    'should be true',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        loggedUserEmail: 'email',
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, true);
    },
  );

  test(
    'are all data loaded, '
    "logged user's name is null, "
    'should be false',
    () {
      state = state.copyWith(
        loggedUserSurname: 'surname',
        loggedUserEmail: 'email',
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, false);
    },
  );

  test(
    'are all data loaded, '
    "logged user's surname is null, "
    'should be false',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserEmail: 'email',
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, false);
    },
  );

  test(
    'are all data loaded, '
    "logged user's email is null, "
    'should be false',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        themeMode: ThemeMode.dark,
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, false);
    },
  );

  test(
    'are all data loaded, '
    'theme mode is null, '
    'should be false',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        loggedUserEmail: 'email',
        language: Language.english,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, false);
    },
  );

  test(
    'are all data loaded, '
    'language is null, '
    'should be false',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        loggedUserEmail: 'email',
        themeMode: ThemeMode.dark,
        distanceUnit: DistanceUnit.kilometers,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, false);
    },
  );

  test(
    'are all data loaded, '
    'distance unit is null, '
    'should be false',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        loggedUserEmail: 'email',
        themeMode: ThemeMode.dark,
        paceUnit: PaceUnit.minutesPerKilometer,
      );

      expect(state.areAllDataLoaded, false);
    },
  );

  test(
    'are all data loaded, '
    'pace unit is null, '
    'should be false',
    () {
      state = state.copyWith(
        loggedUserName: 'name',
        loggedUserSurname: 'surname',
        loggedUserEmail: 'email',
        themeMode: ThemeMode.dark,
        distanceUnit: DistanceUnit.kilometers,
      );

      expect(state.areAllDataLoaded, false);
    },
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
    'copy with drawer page',
    () {
      const DrawerPage expectedDrawerPage = DrawerPage.home;

      state = state.copyWith(drawerPage: expectedDrawerPage);
      final state2 = state.copyWith();

      expect(state.drawerPage, expectedDrawerPage);
      expect(state2.drawerPage, expectedDrawerPage);
    },
  );

  test(
    'copy with bottom nav page',
    () {
      const BottomNavPage expectedBottomNavPage = BottomNavPage.pulseAndWeight;

      state = state.copyWith(bottomNavPage: expectedBottomNavPage);
      final state2 = state.copyWith();

      expect(state.bottomNavPage, expectedBottomNavPage);
      expect(state2.bottomNavPage, expectedBottomNavPage);
    },
  );

  test(
    'copy with logged user email',
    () {
      const String expectedEmail = 'email@example.com';

      state = state.copyWith(loggedUserEmail: expectedEmail);
      final state2 = state.copyWith();

      expect(state.loggedUserEmail, expectedEmail);
      expect(state2.loggedUserEmail, expectedEmail);
    },
  );

  test(
    'copy with logged user name',
    () {
      const String expectedName = 'name';

      state = state.copyWith(loggedUserName: expectedName);
      final state2 = state.copyWith();

      expect(state.loggedUserName, expectedName);
      expect(state2.loggedUserName, expectedName);
    },
  );

  test(
    'copy with logged user surname',
    () {
      const String expectedSurname = 'surname';

      state = state.copyWith(loggedUserSurname: expectedSurname);
      final state2 = state.copyWith();

      expect(state.loggedUserSurname, expectedSurname);
      expect(state2.loggedUserSurname, expectedSurname);
    },
  );

  test(
    'copy with theme mode',
    () {
      const ThemeMode expectedThemeMode = ThemeMode.system;

      state = state.copyWith(themeMode: expectedThemeMode);
      final state2 = state.copyWith();

      expect(state.themeMode, expectedThemeMode);
      expect(state2.themeMode, expectedThemeMode);
    },
  );

  test(
    'copy with language',
    () {
      const Language expectedLanguage = Language.english;

      state = state.copyWith(language: expectedLanguage);
      final state2 = state.copyWith();

      expect(state.language, expectedLanguage);
      expect(state2.language, expectedLanguage);
    },
  );

  test(
    'copy with distance unit',
    () {
      const DistanceUnit expectedDistanceUnit = DistanceUnit.miles;

      state = state.copyWith(distanceUnit: expectedDistanceUnit);
      final state2 = state.copyWith();

      expect(state.distanceUnit, expectedDistanceUnit);
      expect(state2.distanceUnit, expectedDistanceUnit);
    },
  );

  test(
    'copy with pace unit',
    () {
      const PaceUnit expectedPaceUnit = PaceUnit.milesPerHour;

      state = state.copyWith(paceUnit: expectedPaceUnit);
      final state2 = state.copyWith();

      expect(state.paceUnit, expectedPaceUnit);
      expect(state2.paceUnit, expectedPaceUnit);
    },
  );
}
