import 'package:equatable/equatable.dart';

import '../firebase.dart';
import '../mapper/duration_mapper.dart';
import '../mapper/mood_rate_mapper.dart';

abstract class ActivityStatusDto extends Equatable {
  const ActivityStatusDto();

  factory ActivityStatusDto.fromJson(Map<String, dynamic> json) {
    final String status = json[_nameField];
    if (status == 'pending') {
      return const ActivityStatusPendingDto();
    } else if (status == _doneStatusName) {
      return ActivityStatusDoneDto.fromJson(json);
    } else if (status == _abortedStatusName) {
      return ActivityStatusAbortedDto.fromJson(json);
    } else if (status == _undoneStatusName) {
      return const ActivityStatusUndoneDto();
    }
    throw '[ActivityStatusDto] Unknown activity status';
  }

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() => {};
}

class ActivityStatusPendingDto extends ActivityStatusDto {
  const ActivityStatusPendingDto();

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toJson() => {_nameField: _pendingStatusName};
}

class ActivityStatusDoneDto extends ActivityStatusDto with _ActivityStats {
  ActivityStatusDoneDto({
    required double coveredDistanceInKm,
    required PaceDto avgPaceDto,
    required int avgHeartRate,
    required MoodRate moodRate,
    Duration? duration,
    String? comment,
  }) {
    this.coveredDistanceInKm = coveredDistanceInKm;
    this.avgPaceDto = avgPaceDto;
    this.avgHeartRate = avgHeartRate;
    this.moodRate = moodRate;
    this.duration = duration;
    this.comment = comment;
  }

  ActivityStatusDoneDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKm:
              (json[_coveredDistanceInKmField] as num).toDouble(),
          avgPaceDto: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          duration: json[_durationField] != null
              ? mapDurationFromString(json[_durationField])
              : null,
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPaceDto,
        avgHeartRate,
        moodRate,
        duration,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: _doneStatusName,
        _coveredDistanceInKmField: coveredDistanceInKm,
        _avgPaceField: avgPaceDto.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _durationField:
            duration != null ? mapDurationToString(duration!) : null,
        _commentField: comment,
      };
}

class ActivityStatusAbortedDto extends ActivityStatusDto with _ActivityStats {
  ActivityStatusAbortedDto({
    required double coveredDistanceInKm,
    required PaceDto avgPaceDto,
    required int avgHeartRate,
    required MoodRate moodRate,
    Duration? duration,
    String? comment,
  }) {
    this.coveredDistanceInKm = coveredDistanceInKm;
    this.avgPaceDto = avgPaceDto;
    this.avgHeartRate = avgHeartRate;
    this.moodRate = moodRate;
    this.duration = duration;
    this.comment = comment;
  }

  ActivityStatusAbortedDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKm: json[_coveredDistanceInKmField],
          avgPaceDto: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          duration: json[_durationField] != null
              ? mapDurationFromString(json[_durationField])
              : null,
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPaceDto,
        avgHeartRate,
        moodRate,
        duration,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: _abortedStatusName,
        _coveredDistanceInKmField: coveredDistanceInKm,
        _avgPaceField: avgPaceDto.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _durationField:
            duration != null ? mapDurationToString(duration!) : null,
        _commentField: comment,
      };
}

class ActivityStatusUndoneDto extends ActivityStatusDto {
  const ActivityStatusUndoneDto();

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toJson() => {_nameField: _undoneStatusName};
}

mixin _ActivityStats on ActivityStatusDto {
  late final double coveredDistanceInKm;
  late final PaceDto avgPaceDto;
  late final int avgHeartRate;
  late final MoodRate moodRate;
  late final Duration? duration;
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
const String _doneStatusName = 'done';
const String _abortedStatusName = 'aborted';
const String _undoneStatusName = 'undone';

const String _nameField = 'name';
const String _coveredDistanceInKmField = 'coveredDistanceInKilometers';
const String _avgPaceField = 'avgPace';
const String _avgHeartRateField = 'avgHeartRate';
const String _moodRateField = 'moodRate';
const String _durationField = 'duration';
const String _commentField = 'comment';
