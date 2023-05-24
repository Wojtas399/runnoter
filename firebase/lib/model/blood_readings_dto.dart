import 'package:equatable/equatable.dart';

import '../mapper/date_mapper.dart';
import 'blood_parameter_reading_dto.dart';

class BloodReadingsDto extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final List<BloodParameterReadingDto> readingDtos;

  const BloodReadingsDto({
    required this.id,
    required this.userId,
    required this.date,
    required this.readingDtos,
  });

  BloodReadingsDto.fromJson({
    required String id,
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: id,
          userId: userId,
          date: mapDateTimeFromString(json?[_dateField]),
          readingDtos: (json?[_readingsField] as List<Map<String, dynamic>>)
              .map(BloodParameterReadingDto.fromJson)
              .toList(),
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        readingDtos,
      ];

  Map<String, dynamic> toJson() => {
        _dateField: mapDateTimeToString(date),
        _readingsField: readingDtos.map((dto) => dto.toJson()),
      };
}

const String _dateField = 'date';
const String _readingsField = 'readings';
