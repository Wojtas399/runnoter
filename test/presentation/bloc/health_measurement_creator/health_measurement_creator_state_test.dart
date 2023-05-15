import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/health_measurement_creator/bloc/health_measurement_creator_bloc.dart';

void main() {
  late HealthMeasurementCreatorState state;

  HealthMeasurementCreatorState createState({
    BlocStatus status = const BlocStatusInitial(),
    String? restingHeartRateStr,
    String? fastingWeightStr,
  }) =>
      HealthMeasurementCreatorState(
        status: status,
        restingHeartRateStr: restingHeartRateStr,
        fastingWeightStr: fastingWeightStr,
      );

  setUp(() {
    state = createState();
  });

  test(
    'is submit button disabled, '
    'resting heart rate str is null, '
    'should be true',
    () {
      state = state.copyWith(
        fastingWeightStr: '61.5',
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'resting heart rate str is empty, '
    'should be true',
    () {
      state = state.copyWith(
        restingHeartRateStr: '',
        fastingWeightStr: '61.5',
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'fasting weight str is null, '
    'should be true',
    () {
      state = state.copyWith(
        restingHeartRateStr: '50',
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'fasting weight str is empty, '
    'should be true',
    () {
      state = state.copyWith(
        restingHeartRateStr: '50',
        fastingWeightStr: '',
      );

      expect(state.isSubmitButtonDisabled, true);
    },
  );

  test(
    'is submit button disabled, '
    'resting heart rate and fasting weight are not null and not empty, '
    'should be false',
    () {
      state = state.copyWith(
        restingHeartRateStr: '50',
        fastingWeightStr: '61.6',
      );

      expect(state.isSubmitButtonDisabled, false);
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
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 2, 10);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with resting heart rate str',
    () {
      const String expectedValue = '50';

      state = state.copyWith(restingHeartRateStr: expectedValue);
      final state2 = state.copyWith();

      expect(state.restingHeartRateStr, expectedValue);
      expect(state2.restingHeartRateStr, expectedValue);
    },
  );

  test(
    'copy with fasting weight str',
    () {
      const String expectedValue = '61.5';

      state = state.copyWith(fastingWeightStr: expectedValue);
      final state2 = state.copyWith();

      expect(state.fastingWeightStr, expectedValue);
      expect(state2.fastingWeightStr, expectedValue);
    },
  );
}
