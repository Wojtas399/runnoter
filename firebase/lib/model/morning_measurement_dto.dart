import 'package:equatable/equatable.dart';

import '../mapper/date_mapper.dart';

class MorningMeasurementDto extends Equatable {
  final DateTime date;
  final int restingHeartRate;
  final double weight;

  const MorningMeasurementDto({
    required this.date,
    required this.restingHeartRate,
    required this.weight,
  })  : assert(restingHeartRate >= 0),
        assert(weight > 0);

  MorningMeasurementDto.fromJson(
    String dateStr,
    Map<String, dynamic>? json,
  ) : this(
          date: mapDateTimeFromString(dateStr),
          restingHeartRate: json?[_restingHeartRateField],
          weight: json?[_weightField],
        );

  @override
  List<Object?> get props => [
        date,
        restingHeartRate,
        weight,
      ];

  Map<String, dynamic> toJson() => {
        _restingHeartRateField: restingHeartRate,
        _weightField: weight,
      };
}

const String _restingHeartRateField = 'restingHeartRate';
const String _weightField = 'weight';
