import 'package:equatable/equatable.dart';

import '../firebase.dart';
import '../mapper/duration_mapper.dart';
import '../mapper/mood_rate_mapper.dart';

abstract class RunStatusDto extends Equatable {
  const RunStatusDto();

  factory RunStatusDto.fromJson(Map<String, dynamic> json) {
    final String status = json[_nameField];
    if (status == 'pending') {
      return const RunStatusPendingDto();
    } else if (status == _doneStatusName) {
      return RunStatusDoneDto.fromJson(json);
    } else if (status == _abortedStatusName) {
      return RunStatusAbortedDto.fromJson(json);
    } else if (status == _undoneStatusName) {
      return const RunStatusUndoneDto();
    }
    throw '[RunStatusDto] Unknown run status';
  }

  @override
  List<Object?> get props => [];

  Map<String, dynamic> toJson() => {};
}

class RunStatusPendingDto extends RunStatusDto {
  const RunStatusPendingDto();

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toJson() {
    return {
      _nameField: _pendingStatusName,
    };
  }
}

class RunStatusDoneDto extends RunStatusDto with _RunStats {
  RunStatusDoneDto({
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

  RunStatusDoneDto.fromJson(Map<String, dynamic> json)
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

class RunStatusAbortedDto extends RunStatusDto with _RunStats {
  RunStatusAbortedDto({
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

  RunStatusAbortedDto.fromJson(Map<String, dynamic> json)
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

class RunStatusUndoneDto extends RunStatusDto {
  const RunStatusUndoneDto();

  @override
  List<Object> get props => [];

  @override
  Map<String, dynamic> toJson() {
    return {
      _nameField: _undoneStatusName,
    };
  }
}

mixin _RunStats on RunStatusDto {
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
