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

class WorkoutStatusCompletedDto extends WorkoutStatusDto {
  final double coveredDistanceInKilometers;
  final PaceDto avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusCompletedDto({
    required this.coveredDistanceInKilometers,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  WorkoutStatusCompletedDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKilometers:
              (json[_coveredDistanceInKilometersField] as num).toDouble(),
          avgPace: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKilometers,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: _completedStatusName,
        _coveredDistanceInKilometersField: coveredDistanceInKilometers,
        _avgPaceField: avgPace.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _commentField: comment,
      };
}

class WorkoutStatusUncompletedDto extends WorkoutStatusDto {
  final double coveredDistanceInKilometers;
  final PaceDto avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusUncompletedDto({
    required this.coveredDistanceInKilometers,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  WorkoutStatusUncompletedDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKilometers: json[_coveredDistanceInKilometersField],
          avgPace: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKilometers,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: _uncompletedStatusName,
        _coveredDistanceInKilometersField: coveredDistanceInKilometers,
        _avgPaceField: avgPace.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _commentField: comment,
      };
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
const String _coveredDistanceInKilometersField = 'coveredDistanceInKilometers';
const String _avgPaceField = 'avgPace';
const String _avgHeartRateField = 'avgHeartRate';
const String _moodRateField = 'moodRate';
const String _commentField = 'comment';
