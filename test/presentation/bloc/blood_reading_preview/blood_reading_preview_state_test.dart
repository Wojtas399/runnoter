import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';
import 'package:runnoter/presentation/model/bloc_status.dart';
import 'package:runnoter/presentation/screen/blood_test_preview/bloc/blood_reading_preview_bloc.dart';

void main() {
  late BloodReadingPreviewState state;

  setUp(
    () => state = const BloodReadingPreviewState(
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
    'copy with blood reading id',
    () {
      const String expectedId = 'br1';

      state = state.copyWith(bloodReadingId: expectedId);
      final state2 = state.copyWith();

      expect(state.bloodReadingId, expectedId);
      expect(state2.bloodReadingId, expectedId);
    },
  );

  test(
    'copy with date',
    () {
      final DateTime expectedDate = DateTime(2023, 5, 1);

      state = state.copyWith(date: expectedDate);
      final state2 = state.copyWith();

      expect(state.date, expectedDate);
      expect(state2.date, expectedDate);
    },
  );

  test(
    'copy with read parameters',
    () {
      const List<BloodReadingParameter> expectedReadParameters = [
        BloodReadingParameter(
          parameter: BloodParameter.wbc,
          readingValue: 4.45,
        ),
        BloodReadingParameter(
          parameter: BloodParameter.cpk,
          readingValue: 210,
        ),
      ];

      state = state.copyWith(readParameters: expectedReadParameters);
      final state2 = state.copyWith();

      expect(state.readParameters, expectedReadParameters);
      expect(state2.readParameters, expectedReadParameters);
    },
  );
}
