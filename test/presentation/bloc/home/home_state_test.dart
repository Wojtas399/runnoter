import 'package:flutter_test/flutter_test.dart';
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
}
