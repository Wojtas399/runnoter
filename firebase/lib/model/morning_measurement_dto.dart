import 'package:equatable/equatable.dart';

import '../mapper/date_mapper.dart';

class MorningMeasurementDto extends Equatable {
  final DateTime date;
  final int restingHeartRate;
  final double fastingWeight;

  const MorningMeasurementDto({
    required this.date,
    required this.restingHeartRate,
    required this.fastingWeight,
  })  : assert(restingHeartRate >= 0),
        assert(fastingWeight > 0);

  MorningMeasurementDto.fromJson(
    String dateStr,
    Map<String, dynamic>? json,
  ) : this(
          date: mapDateTimeFromString(dateStr),
          restingHeartRate: json?[_restingHeartRateField],
          fastingWeight: json?[_fastingWeightField],
        );

  @override
  List<Object?> get props => [
        date,
        restingHeartRate,
        fastingWeight,
      ];

  Map<String, dynamic> toJson() => {
        _restingHeartRateField: restingHeartRate,
        _fastingWeightField: fastingWeight,
      };
}

const String _restingHeartRateField = 'restingHeartRate';
const String _fastingWeightField = 'fastingWeight';
