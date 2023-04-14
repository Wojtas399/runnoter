import 'package:equatable/equatable.dart';

class WorkoutStageDto extends Equatable {
  const WorkoutStageDto();

  factory WorkoutStageDto.fromJson(Map<String, dynamic> json) {
    final String stageName = json[_nameField];
    if (stageName == 'owb') {
      return WorkoutStageOWBDto.fromJson(json);
    } else if (stageName == 'bc2') {
      return WorkoutStageBC2Dto.fromJson(json);
    } else if (stageName == 'bc3') {
      return WorkoutStageBC3Dto.fromJson(json);
    } else if (stageName == 'strength') {
      return WorkoutStageStrengthDto.fromJson(json);
    } else if (stageName == 'rhythms') {
      return WorkoutStageRhythmsDto.fromJson(json);
    } else {
      throw '[WorkoutStageDto] Unknown stage type';
    }
  }

  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson() => {};
}

class WorkoutStageOWBDto extends WorkoutStageDto with _DistanceWorkout {
  WorkoutStageOWBDto({
    required double distanceInKilometers,
    required int maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0) {
    stageName = 'owb';
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  WorkoutStageOWBDto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKilometers:
              (json[_distanceInKilometersField] as num).toDouble(),
          maxHeartRate: json[_maxHeartRateField],
        );

  @override
  List<Object> get props => [
        stageName,
        distanceInKilometers,
        maxHeartRate,
      ];
}

class WorkoutStageBC2Dto extends WorkoutStageDto with _DistanceWorkout {
  WorkoutStageBC2Dto({
    required double distanceInKilometers,
    required int maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0) {
    stageName = 'bc2';
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  WorkoutStageBC2Dto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKilometers:
              (json[_distanceInKilometersField] as num).toDouble(),
          maxHeartRate: json[_maxHeartRateField],
        );

  @override
  List<Object> get props => [
        stageName,
        distanceInKilometers,
        maxHeartRate,
      ];
}

class WorkoutStageBC3Dto extends WorkoutStageDto with _DistanceWorkout {
  WorkoutStageBC3Dto({
    required double distanceInKilometers,
    required int maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0) {
    stageName = 'bc3';
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  WorkoutStageBC3Dto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKilometers:
              (json[_distanceInKilometersField] as num).toDouble(),
          maxHeartRate: json[_maxHeartRateField],
        );

  @override
  List<Object> get props => [
        stageName,
        distanceInKilometers,
        maxHeartRate,
      ];
}

class WorkoutStageStrengthDto extends WorkoutStageDto with _SeriesWorkout {
  WorkoutStageStrengthDto({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int breakMarchDistanceInMeters,
    required int breakJogDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(breakMarchDistanceInMeters > 0 || breakJogDistanceInMeters > 0) {
    stageName = 'strength';
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.breakMarchDistanceInMeters = breakMarchDistanceInMeters;
    this.breakJogDistanceInMeters = breakJogDistanceInMeters;
  }

  WorkoutStageStrengthDto.fromJson(Map<String, dynamic> json)
      : this(
          amountOfSeries: json[_amountOfSeriesField],
          seriesDistanceInMeters: json[_seriesDistanceInMetersField],
          breakMarchDistanceInMeters: json[_breakMarchDistanceInMetersField],
          breakJogDistanceInMeters: json[_breakJogDistanceInMetersField],
        );

  @override
  List<Object> get props => [
        stageName,
        amountOfSeries,
        seriesDistanceInMeters,
        breakMarchDistanceInMeters,
        breakJogDistanceInMeters,
      ];
}

class WorkoutStageRhythmsDto extends WorkoutStageDto with _SeriesWorkout {
  WorkoutStageRhythmsDto({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int breakMarchDistanceInMeters,
    required int breakJogDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(breakMarchDistanceInMeters > 0 || breakJogDistanceInMeters > 0) {
    stageName = 'rhythms';
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.breakMarchDistanceInMeters = breakMarchDistanceInMeters;
    this.breakJogDistanceInMeters = breakJogDistanceInMeters;
  }

  WorkoutStageRhythmsDto.fromJson(Map<String, dynamic> json)
      : this(
          amountOfSeries: json[_amountOfSeriesField],
          seriesDistanceInMeters: json[_seriesDistanceInMetersField],
          breakMarchDistanceInMeters: json[_breakMarchDistanceInMetersField],
          breakJogDistanceInMeters: json[_breakJogDistanceInMetersField],
        );

  @override
  List<Object> get props => [
        stageName,
        amountOfSeries,
        seriesDistanceInMeters,
        breakMarchDistanceInMeters,
        breakJogDistanceInMeters,
      ];
}

mixin _DistanceWorkout on WorkoutStageDto {
  late final String stageName;
  late final double distanceInKilometers;
  late final int maxHeartRate;

  @override
  Map<String, dynamic> toJson() => {
        _nameField: stageName,
        _distanceInKilometersField: distanceInKilometers,
        _maxHeartRateField: maxHeartRate,
      };
}

mixin _SeriesWorkout on WorkoutStageDto {
  late final String stageName;
  late final int amountOfSeries;
  late final int seriesDistanceInMeters;
  late final int breakMarchDistanceInMeters;
  late final int breakJogDistanceInMeters;

  @override
  Map<String, dynamic> toJson() => {
        _nameField: stageName,
        _amountOfSeriesField: amountOfSeries,
        _seriesDistanceInMetersField: seriesDistanceInMeters,
        _breakMarchDistanceInMetersField: breakMarchDistanceInMeters,
        _breakJogDistanceInMetersField: breakJogDistanceInMeters,
      };
}

const String _nameField = 'name';
const String _distanceInKilometersField = 'distanceInKilometers';
const String _maxHeartRateField = 'maxHeartRate';
const String _amountOfSeriesField = 'amountOfSeries';
const String _seriesDistanceInMetersField = 'seriesDistanceInMeters';
const String _breakMarchDistanceInMetersField = 'breakMarchDistanceInMeters';
const String _breakJogDistanceInMetersField = 'breakJogDistanceInMeters';
