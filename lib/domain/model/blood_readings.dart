import 'package:equatable/equatable.dart';

import 'blood_parameter.dart';
import 'entity.dart';

class BloodReadings extends Entity {
  final String userId;
  final DateTime date;
  final List<BloodParameterReading> readings;

  const BloodReadings({
    required super.id,
    required this.userId,
    required this.date,
    required this.readings,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        readings,
      ];
}

class BloodParameterReading extends Equatable {
  final BloodParameter parameter;
  final double reading;

  const BloodParameterReading({
    required this.parameter,
    required this.reading,
  });

  @override
  List<Object?> get props => [
        parameter,
        reading,
      ];
}
