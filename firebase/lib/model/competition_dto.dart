import 'package:equatable/equatable.dart';

import '../firebase.dart';
import '../mapper/date_mapper.dart';
import 'time_dto.dart';

class CompetitionDto extends Equatable {
  final String id;
  final String userId;
  final String name;
  final DateTime date;
  final String place;
  final double distance;
  final TimeDto expectedTimeDto;
  final RunStatusDto runStatusDto;

  const CompetitionDto({
    required this.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.place,
    required this.distance,
    required this.expectedTimeDto,
    required this.runStatusDto,
  });

  CompetitionDto.fromJson({
    required String competitionId,
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: competitionId,
          userId: userId,
          name: json?[_nameField],
          date: mapDateTimeFromString(json?[_dateField]),
          place: json?[_placeField],
          distance: (json?[_distanceField] as num).toDouble(),
          expectedTimeDto: TimeDto.fromString(json?[_expectedTimeField]),
          runStatusDto: RunStatusDto.fromJson(json?[_statusField]),
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        date,
        place,
        distance,
        expectedTimeDto,
        runStatusDto,
      ];

  Map<String, dynamic> toJson() => {
        _nameField: name,
        _dateField: mapDateTimeToString(date),
        _placeField: place,
        _distanceField: distance,
        _expectedTimeField: expectedTimeDto.toString(),
        _statusField: runStatusDto.toJson(),
      };
}

const String _nameField = 'name';
const String _dateField = 'date';
const String _placeField = 'place';
const String _distanceField = 'distance';
const String _expectedTimeField = 'expectedTime';
const String _statusField = 'status';
