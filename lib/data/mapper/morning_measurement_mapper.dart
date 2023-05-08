import 'package:firebase/firebase.dart';

import '../../domain/model/morning_measurement.dart';

MorningMeasurementDto mapMorningMeasurementToFirebase(
  MorningMeasurement morningMeasurement,
) =>
    MorningMeasurementDto(
      date: morningMeasurement.date,
      restingHeartRate: morningMeasurement.restingHeartRate,
      weight: morningMeasurement.weight,
    );

MorningMeasurement mapMorningMeasurementFromFirebase(
  MorningMeasurementDto morningMeasurementDto,
) =>
    MorningMeasurement(
      date: morningMeasurementDto.date,
      restingHeartRate: morningMeasurementDto.restingHeartRate,
      weight: morningMeasurementDto.weight,
    );
