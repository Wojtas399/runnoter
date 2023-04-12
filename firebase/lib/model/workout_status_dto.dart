part of firebase;

class WorkoutStatusDto extends Equatable {
  const WorkoutStatusDto();

  factory WorkoutStatusDto.fromJson(Map<String, dynamic> json) {
    final String status = json[_nameField];
    if (status == 'pending') {
      return const WorkoutStatusPendingDto();
    } else if (status == 'done') {
      return WorkoutStatusDoneDto.fromJson(json);
    } else if (status == 'failed') {
      return WorkoutStatusFailedDto.fromJson(json);
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
      _nameField: 'pending',
    };
  }
}

class WorkoutStatusDoneDto extends WorkoutStatusDto {
  final double coveredDistanceInKm;
  final PaceDto avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusDoneDto({
    required this.coveredDistanceInKm,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  WorkoutStatusDoneDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKm: json[_coveredDistanceInKmField],
          avgPace: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: 'done',
        _coveredDistanceInKmField: coveredDistanceInKm,
        _avgPaceField: avgPace.toJson(),
        _avgHeartRateField: avgHeartRate,
        _moodRateField: moodRate.number,
        _commentField: comment,
      };
}

class WorkoutStatusFailedDto extends WorkoutStatusDto {
  final double coveredDistanceInKm;
  final PaceDto avgPace;
  final int avgHeartRate;
  final MoodRate moodRate;
  final String? comment;

  const WorkoutStatusFailedDto({
    required this.coveredDistanceInKm,
    required this.avgPace,
    required this.avgHeartRate,
    required this.moodRate,
    required this.comment,
  });

  WorkoutStatusFailedDto.fromJson(Map<String, dynamic> json)
      : this(
          coveredDistanceInKm: json[_coveredDistanceInKmField],
          avgPace: PaceDto.fromJson(json[_avgPaceField]),
          avgHeartRate: json[_avgHeartRateField],
          moodRate: mapMoodRateFromNumber(json[_moodRateField]),
          comment: json[_commentField],
        );

  @override
  List<Object?> get props => [
        coveredDistanceInKm,
        avgPace,
        avgHeartRate,
        moodRate,
        comment,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _statusTypeField: 'failed',
        _coveredDistanceInKmField: coveredDistanceInKm,
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

const String _statusTypeField = 'type';
const String _coveredDistanceInKmField = 'coveredDistanceInKm';
const String _avgPaceField = 'avgPace';
const String _avgHeartRateField = 'avgHeartRate';
const String _moodRateField = 'moodRate';
const String _commentField = 'comment';
