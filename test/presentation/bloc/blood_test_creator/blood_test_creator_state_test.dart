import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/blood_test_parameter.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_test_creator/bloc/blood_test_creator_bloc.dart';

import '../../../util/blood_test_parameter_creator.dart';

void main() {
  late BloodTestCreatorState state;

  setUp(
    () => state = const BloodTestCreatorState(
      status: BlocStatusInitial(),
    ),
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
    'copy with parameters',
    () {
      final List<BloodTestParameter> expectedParameters = [
        createBloodTestParameter(id: 'p1'),
        createBloodTestParameter(id: 'p2'),
      ];

      state = state.copyWith(parameters: expectedParameters);
      final state2 = state.copyWith();

      expect(state.parameters, expectedParameters);
      expect(state2.parameters, expectedParameters);
    },
  );
}
