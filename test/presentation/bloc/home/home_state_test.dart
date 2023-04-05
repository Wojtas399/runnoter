import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/settings.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/home/bloc/home_state.dart';

void main() {
  late HomeState state;

  setUp(() {
    state = const HomeState(
      status: BlocStatusInitial(),
      currentPage: HomePage.currentWeek,
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
    'copy with current page',
    () {
      const HomePage expectedCurrentPage = HomePage.pulseAndWeight;

      state = state.copyWith(currentPage: expectedCurrentPage);
      final state2 = state.copyWith();

      expect(state.currentPage, expectedCurrentPage);
      expect(state2.currentPage, expectedCurrentPage);
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
}
