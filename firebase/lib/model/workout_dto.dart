import 'package:equatable/equatable.dart';

import '../mapper/additional_workout_mapper.dart';
import '../mapper/date_mapper.dart';
import 'workout_stage_dto.dart';
import 'workout_status_dto.dart';

class WorkoutDto extends Equatable {
  final String userId;
  final DateTime date;
  final WorkoutStatusDto status;
  final String name;
  final List<WorkoutStageDto> stages;
  final AdditionalWorkout? additionalWorkout;

  const WorkoutDto({
    required this.userId,
    required this.date,
    required this.status,
    required this.name,
    required this.stages,
    required this.additionalWorkout,
  });

  WorkoutDto.fromJson(String userId, Map<String, dynamic> json)
      : this(
          userId: userId,
          date: mapDateTimeFromString(json[_dateField]),
          status: WorkoutStatusDto.fromJson(json[_statusField]),
          name: json[_nameField],
          stages: (json[_stagesField] as List)
              .map(
                (json) => WorkoutStageDto.fromJson(json),
              )
              .toList(),
          additionalWorkout: mapAdditionalWorkoutFromString(
            json[_additionalWorkoutField],
          ),
        );

  @override
  List<Object?> get props => [
        userId,
        date,
        status,
        name,
        stages,
        additionalWorkout,
      ];

  Map<String, dynamic> toJson() => {
        _dateField: mapDateTimeToString(date),
        _statusField: status.toJson(),
        _nameField: name,
        _stagesField: stages.map(
          (WorkoutStageDto stage) => stage.toJson(),
        ),
        _additionalWorkoutField: additionalWorkout?.name,
      };
}

enum AdditionalWorkout {
  stretching,
  strengthening,
}

const String _dateField = 'date';
const String _statusField = 'status';
const String _nameField = 'name';
const String _stagesField = 'stages';
const String _additionalWorkoutField = 'additionalWorkout';
