import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/ui/cubit/reauthentication/reauthentication_cubit.dart';

void main() {
  late ReauthenticationState state;

  setUp(
    () => state = const ReauthenticationState(status: CubitStatusInitial()),
  );

  test(
    'copy with status, '
    'should set complete status if new status is null',
    () {
      const CubitStatus expected = CubitStatusLoading();

      state = state.copyWith(status: expected);
      final state2 = state.copyWith();

      expect(state.status, expected);
      expect(state2.status, const CubitStatusComplete());
    },
  );

  test(
    'copy with password, '
    'should copy current value if new value is null',
    () {
      const String expected = 'passwd321';

      state = state.copyWith(password: expected);
      final state2 = state.copyWith();

      expect(state.password, expected);
      expect(state2.password, expected);
    },
  );
}
