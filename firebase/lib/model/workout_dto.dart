import 'package:equatable/equatable.dart';

import '../firebase.dart';
import '../mapper/date_mapper.dart';

class WorkoutDto extends Equatable {
  final String id;
  final String userId;
  final DateTime date;
  final WorkoutStatusDto status;
  final String name;
  final List<WorkoutStageDto> stages;

  const WorkoutDto({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.name,
    required this.stages,
  });

  WorkoutDto.fromJson({
    required String docId,
    required String userId,
    required Map<String, dynamic>? json,
  }) : this(
          id: docId,
          userId: userId,
          date: mapDateTimeFromString(json?[workoutDtoDateField]),
          status: WorkoutStatusDto.fromJson(json?[_statusField]),
          name: json?[_nameField],
          stages: (json?[_stagesField] as List)
              .map(
                (json) => WorkoutStageDto.fromJson(json),
              )
              .toList(),
        );

  @override
  List<Object?> get props => [
        userId,
        date,
        status,
        name,
        stages,
      ];

  Map<String, dynamic> toJson() => {
        workoutDtoDateField: mapDateTimeToString(date),
        _statusField: status.toJson(),
        _nameField: name,
        _stagesField: stages.map(
          (WorkoutStageDto stage) => stage.toJson(),
        ),
      };
}

const String workoutDtoDateField = 'date';
const String _statusField = 'status';
const String _nameField = 'name';
const String _stagesField = 'stages';
