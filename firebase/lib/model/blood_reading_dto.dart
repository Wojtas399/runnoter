import 'package:equatable/equatable.dart';

import '../mapper/date_mapper.dart';
import 'blood_reading_parameter_dto.dart';

class BloodReadingDto extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final List<BloodReadingParameterDto> parameterDtos;

  const BloodReadingDto({
    required this.id,
    required this.userId,
    required this.date,
    required this.parameterDtos,
  });

  BloodReadingDto.fromJson({
    required String id,
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: id,
          userId: userId,
          date: mapDateTimeFromString(json?[_dateField]),
          parameterDtos: (json?[_parametersField] as List<Map<String, dynamic>>)
              .map(BloodReadingParameterDto.fromJson)
              .toList(),
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        parameterDtos,
      ];

  Map<String, dynamic> toJson() => {
        _dateField: mapDateTimeToString(date),
        _parametersField: parameterDtos.map((dto) => dto.toJson()),
      };
}

const String _dateField = 'date';
const String _parametersField = 'parameters';
