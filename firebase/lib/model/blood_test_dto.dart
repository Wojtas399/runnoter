import 'package:equatable/equatable.dart';

import '../mapper/date_mapper.dart';
import 'blood_parameter_result_dto.dart';

class BloodTestDto extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final List<BloodParameterResultDto> parameterResultDtos;

  const BloodTestDto({
    required this.id,
    required this.userId,
    required this.date,
    required this.parameterResultDtos,
  });

  BloodTestDto.fromJson({
    required String id,
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: id,
          userId: userId,
          date: mapDateTimeFromString(json?[_dateField]),
          parameterResultDtos: (json?[_parameterResultsField] as List)
              .map((json) => BloodParameterResultDto.fromJson(json))
              .toList(),
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        parameterResultDtos,
      ];

  Map<String, dynamic> toJson() => {
        _dateField: mapDateTimeToString(date),
        _parameterResultsField: parameterResultDtos.map((dto) => dto.toJson()),
      };
}

Map<String, dynamic> createBloodTestJsonToUpdate({
  DateTime? date,
  List<BloodParameterResultDto>? parameterResultDtos,
}) =>
    {
      if (date != null) _dateField: date,
      if (parameterResultDtos != null)
        _parameterResultsField: parameterResultDtos.map(
          (dto) => dto.toJson(),
        ),
    };

const String _dateField = 'date';
const String _parameterResultsField = 'parameterResults';
