import 'package:equatable/equatable.dart';

import 'blood_parameter.dart';
import 'entity.dart';

class BloodReading extends Entity {
  final String userId;
  final DateTime date;
  final List<BloodReadingParameter> parameters;

  const BloodReading({
    required super.id,
    required this.userId,
    required this.date,
    required this.parameters,
  }) : assert(parameters.length > 0);

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        parameters,
      ];
}

class BloodReadingParameter extends Equatable {
  final BloodParameter parameter;
  final double readingValue;

  const BloodReadingParameter({
    required this.parameter,
    required this.readingValue,
  });

  @override
  List<Object?> get props => [
        parameter,
        readingValue,
      ];
}
