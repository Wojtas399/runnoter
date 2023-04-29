import 'package:equatable/equatable.dart';

import '../firebase.dart';
import '../mapper/mood_rate_mapper.dart';

class WorkoutStatusDto extends Equatable {
  const WorkoutStatusDto();

  factory WorkoutStatusDto.fromJson(Map<String, dynamic> json) {
    final String status = json[_nameField];
    if (status == 'pending') {
      return const WorkoutStatusPendingDto();
    } else if (status == _completedStatusName) {
      return WorkoutStatusCompletedDto.fromJson(json);
    } else if (status == _uncompletedStatusName) {
      return WorkoutStatusUncompletedDto.fromJson(json);
    }
    throw '[WorkoutStatusDto] Unknown workout status';
  }

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() => {};
}

class WorkoutStatusPendingDto extends WorkoutStatusDto {
  const WorkoutStatusPendingDto();

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toJson() {
    return {
      _nameField: _pendingStatusName,
    };
  }
}

class WorkoutStatusCompletedDto extends WorkoutStatusDto with _FinishedWorkout {
  WorkoutStatusCompletedDto({
    required double coveredDistanceInKm,
    required PaceDto avgPaceDto,
    required int avgHeartRate,
    required MoodRate moodRate,
    required String? comment,
  }) {
    this.coveredDistanceInKm = coveredDistanceInKm;
    this.avgPaceDto = avgPaceDto;
    this.avgHeartRate = avgHeartRate;
    this.moodRate = moodRate;
    this.comment = comment;
  }

  WorkoutStatusCompletedDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKm:
              (json[_coveredDistanceInKmField] as num).toDouble(),
          avgPaceDto: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPaceDto,
        avgHeartRate,
        moodRate,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: _completedStatusName,
        _coveredDistanceInKmField: coveredDistanceInKm,
        _avgPaceField: avgPaceDto.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _commentField: comment,
      };
}

class WorkoutStatusUncompletedDto extends WorkoutStatusDto
    with _FinishedWorkout {
  WorkoutStatusUncompletedDto({
    required double coveredDistanceInKm,
    required PaceDto avgPaceDto,
    required int avgHeartRate,
    required MoodRate moodRate,
    required String? comment,
  }) {
    this.coveredDistanceInKm = coveredDistanceInKm;
    this.avgPaceDto = avgPaceDto;
    this.avgHeartRate = avgHeartRate;
    this.moodRate = moodRate;
    this.comment = comment;
  }

  WorkoutStatusUncompletedDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKm: json[_coveredDistanceInKmField],
          avgPaceDto: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPaceDto,
        avgHeartRate,
        moodRate,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: _uncompletedStatusName,
        _coveredDistanceInKmField: coveredDistanceInKm,
        _avgPaceField: avgPaceDto.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _commentField: comment,
      };
}

mixin _FinishedWorkout on WorkoutStatusDto {
  late final double coveredDistanceInKm;
  late final PaceDto avgPaceDto;
  late final int avgHeartRate;
  late final MoodRate moodRate;
  late final String? comment;
}

enum MoodRate {
  mr1(1),
  mr2(2),
  mr3(3),
  mr4(4),
  mr5(5),
  mr6(6),
  mr7(7),
  mr8(8),
  mr9(9),
  mr10(10);

  final int number;

  const MoodRate(this.number);
}

const String _pendingStatusName = 'pending';
const String _completedStatusName = 'completed';
const String _uncompletedStatusName = 'uncompleted';

const String _nameField = 'name';
const String _coveredDistanceInKmField = 'coveredDistanceInKilometers';
const String _avgPaceField = 'avgPace';
const String _avgHeartRateField = 'avgHeartRate';
const String _moodRateField = 'moodRate';
const String _commentField = 'comment';
