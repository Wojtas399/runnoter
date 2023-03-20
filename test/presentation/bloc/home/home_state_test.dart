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
}
