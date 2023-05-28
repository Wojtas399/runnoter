import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_readings_creator/bloc/blood_reading_creator_bloc.dart';

void main() {
  late BloodReadingCreatorState state;

  setUp(
    () => state = const BloodReadingCreatorState(
      status: BlocStatusInitial(),
    ),
  );

  test(
    'are date valid, '
    'date is null, '
    'should be false',
    () {
      state = state.copyWith(
        date: null,
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
        ],
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'blood reading parameters are null, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 12),
        bloodReadingParameters: null,
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'list of blood reading parameters is empty, '
    'should be false',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 20),
        bloodReadingParameters: const [],
      );

      expect(state.areDataValid, false);
    },
  );

  test(
    'are data valid, '
    'date and blood reading parameters are valid, '
    'should be true',
    () {
      state = state.copyWith(
        date: DateTime(2023, 5, 20),
        bloodReadingParameters: const [
          BloodReadingParameter(
            parameter: BloodParameter.wbc,
            readingValue: 4.45,
          ),
        ],
      );

      expect(state.areDataValid, true);
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
      final DateTime expectedDate = DateTime(2023, 5, 20);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with blood reading parameters',
    () {
      const List<BloodReadingParameter> expectedParameters = [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.45,
        ),
      ];

      state = state.copyWith(bloodReadingParameters: expectedParameters);
      final state2 = state.copyWith();

      expect(state.bloodReadingParameters, expectedParameters);
      expect(state2.bloodReadingParameters, expectedParameters);
    },
  );
}
