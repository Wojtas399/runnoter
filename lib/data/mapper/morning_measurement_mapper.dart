import 'package:firebase/firebase.dart';

import '../../domain/model/morning_measurement.dart';

MorningMeasurementDto mapMorningMeasurementToFirebase(
  MorningMeasurement morningMeasurement,
) =>
    MorningMeasurementDto(
      date: morningMeasurement.date,
      restingHeartRate: morningMeasurement.restingHeartRate,
      fastingWeight: morningMeasurement.fastingWeight,
    );

MorningMeasurement mapMorningMeasurementFromFirebase(
  MorningMeasurementDto morningMeasurementDto,
) =>
    MorningMeasurement(
      date: morningMeasurementDto.date,
      restingHeartRate: morningMeasurementDto.restingHeartRate,
      fastingWeight: morningMeasurementDto.fastingWeight,
    );
