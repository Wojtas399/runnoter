import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/blood_reading_mapper.dart';
import 'package:runnoter/domain/model/blood_parameter.dart';
import 'package:runnoter/domain/model/blood_reading.dart';

void main() {
  const String readingsId = 'r1';
  const String userId = 'u1';
  final DateTime date = DateTime(2023, 5, 14);
  final BloodReading bloodReading = BloodReading(
    id: readingsId,
    userId: userId,
    date: date,
    parameters: const [
      BloodReadingParameter(
        parameter: BloodParameter.wbc,
        readingValue: 4.45,
      ),
      BloodReadingParameter(
        parameter: BloodParameter.ldl,
        readingValue: 78,
      ),
    ],
  );
  final firebase.BloodReadingDto bloodReadingDto = firebase.BloodReadingDto(
    id: readingsId,
    userId: userId,
    date: date,
    parameterDtos: const [
      firebase.BloodReadingParameterDto(
        parameter: firebase.BloodParameter.wbc,
        readingValue: 4.45,
      ),
      firebase.BloodReadingParameterDto(
        parameter: firebase.BloodParameter.ldl,
        readingValue: 78,
      ),
    ],
  );

  test(
    'map blood reading from dto, '
    'should map blood reading dto to domain model',
    () {
      final mappedModel = mapBloodReadingFromDto(bloodReadingDto);

      expect(mappedModel, bloodReading);
    },
  );
}
