import 'package:equatable/equatable.dart';

import '../mapper/date_mapper.dart';

class HealthMeasurementDto extends Equatable {
  final String userId;
  final DateTime date;
  final int restingHeartRate;
  final double fastingWeight;

  const HealthMeasurementDto({
    required this.userId,
    required this.date,
    required this.restingHeartRate,
    required this.fastingWeight,
  })  : assert(restingHeartRate >= 0),
        assert(fastingWeight > 0);

  HealthMeasurementDto.fromJson({
    required String userId,
    required String dateStr,
    required Map<String, dynamic>? json,
  }) : this(
          userId: userId,
          date: mapDateTimeFromString(dateStr),
          restingHeartRate: json?[_restingHeartRateField],
          fastingWeight: (json?[_fastingWeightField] as num).toDouble(),
        );

  @override
  List<Object?> get props => [
        userId,
        date,
        restingHeartRate,
        fastingWeight,
      ];

  Map<String, dynamic> toJson() => {
        _restingHeartRateField: restingHeartRate,
        _fastingWeightField: fastingWeight,
      };
}

Map<String, dynamic> createHealthMeasurementJsonToUpdate({
  int? restingHeartRate,
  double? fastingWeight,
}) =>
    {
      if (restingHeartRate != null) _restingHeartRateField: restingHeartRate,
      if (fastingWeight != null) _fastingWeightField: fastingWeight,
    };

const String _restingHeartRateField = 'restingHeartRate';
const String _fastingWeightField = 'fastingWeight';
