import 'package:equatable/equatable.dart';

class WorkoutStageDto extends Equatable {
  const WorkoutStageDto();

  factory WorkoutStageDto.fromJson(Map<String, dynamic> json) {
    final String stageName = json[_nameField];
    if (stageName == 'baseRun') {
      return WorkoutStageBaseRunDto.fromJson(json);
    } else if (stageName == 'zone2') {
      return WorkoutStageZone2Dto.fromJson(json);
    } else if (stageName == 'zone3') {
      return WorkoutStageZone3Dto.fromJson(json);
    } else if (stageName == 'hillRepeats') {
      return WorkoutStageHillRepeatsDto.fromJson(json);
    } else if (stageName == 'rhythms') {
      return WorkoutStageRhythmsDto.fromJson(json);
    } else if (stageName == 'stretching') {
      return const WorkoutStageStretchingDto();
    } else if (stageName == 'strengthening') {
      return const WorkoutStageStrengtheningDto();
    } else if (stageName == 'foamRolling') {
      return const WorkoutStageFoamRollingDto();
    } else {
      throw '[WorkoutStageDto] Unknown stage type';
    }
  }

  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson() => {};
}

class WorkoutStageBaseRunDto extends WorkoutStageDto with _DistanceWorkout {
  WorkoutStageBaseRunDto({
    required double distanceInKilometers,
    required int maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0) {
    stageName = 'baseRun';
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  WorkoutStageBaseRunDto.fromJson(Map<String, dynamic> json)
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

class WorkoutStageZone2Dto extends WorkoutStageDto with _DistanceWorkout {
  WorkoutStageZone2Dto({
    required double distanceInKilometers,
    required int maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0) {
    stageName = 'zone2';
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  WorkoutStageZone2Dto.fromJson(Map<String, dynamic> json)
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

class WorkoutStageZone3Dto extends WorkoutStageDto with _DistanceWorkout {
  WorkoutStageZone3Dto({
    required double distanceInKilometers,
    required int maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0) {
    stageName = 'zone3';
    this.distanceInKilometers = distanceInKilometers;
    this.maxHeartRate = maxHeartRate;
  }

  WorkoutStageZone3Dto.fromJson(Map<String, dynamic> json)
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

class WorkoutStageHillRepeatsDto extends WorkoutStageDto with _SeriesWorkout {
  WorkoutStageHillRepeatsDto({
    required int amountOfSeries,
    required int seriesDistanceInMeters,
    required int breakMarchDistanceInMeters,
    required int breakJogDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(breakMarchDistanceInMeters > 0 || breakJogDistanceInMeters > 0) {
    stageName = 'hillRepeats';
    this.amountOfSeries = amountOfSeries;
    this.seriesDistanceInMeters = seriesDistanceInMeters;
    this.breakMarchDistanceInMeters = breakMarchDistanceInMeters;
    this.breakJogDistanceInMeters = breakJogDistanceInMeters;
  }

  WorkoutStageHillRepeatsDto.fromJson(Map<String, dynamic> json)
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

class WorkoutStageStretchingDto extends WorkoutStageDto {
  const WorkoutStageStretchingDto();

  @override
  Map<String, dynamic> toJson() => {
        _nameField: 'stretching',
      };
}

class WorkoutStageStrengtheningDto extends WorkoutStageDto {
  const WorkoutStageStrengtheningDto();

  @override
  Map<String, dynamic> toJson() => {
        _nameField: 'strengthening',
      };
}

class WorkoutStageFoamRollingDto extends WorkoutStageDto {
  const WorkoutStageFoamRollingDto();

  @override
  Map<String, dynamic> toJson() => {
        _nameField: 'foamRolling',
      };
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
