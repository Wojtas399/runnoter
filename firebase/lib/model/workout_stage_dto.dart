import 'package:equatable/equatable.dart';

sealed class WorkoutStageDto extends Equatable {
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
    } else {
      throw '[WorkoutStageDto] Unknown stage type';
    }
  }

  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson() => {};
}

sealed class _DistanceWorkout extends WorkoutStageDto {
  final String nameField;
  final double distanceInKilometers;
  final int maxHeartRate;

  const _DistanceWorkout({
    required this.nameField,
    required this.distanceInKilometers,
    required this.maxHeartRate,
  }) : assert(distanceInKilometers > 0 && maxHeartRate > 0);

  @override
  List<Object> get props => [
        nameField,
        distanceInKilometers,
        maxHeartRate,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: nameField,
        _distanceInKilometersField: distanceInKilometers,
        _maxHeartRateField: maxHeartRate,
      };
}

sealed class _SeriesWorkout extends WorkoutStageDto {
  final String nameField;
  final int amountOfSeries;
  final int seriesDistanceInMeters;
  final int walkingDistanceInMeters;
  final int joggingDistanceInMeters;

  const _SeriesWorkout({
    required this.nameField,
    required this.amountOfSeries,
    required this.seriesDistanceInMeters,
    required this.walkingDistanceInMeters,
    required this.joggingDistanceInMeters,
  })  : assert(amountOfSeries > 0),
        assert(seriesDistanceInMeters > 0),
        assert(walkingDistanceInMeters > 0 || joggingDistanceInMeters > 0);

  @override
  List<Object> get props => [
        nameField,
        amountOfSeries,
        seriesDistanceInMeters,
        walkingDistanceInMeters,
        joggingDistanceInMeters,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _nameField: nameField,
        _amountOfSeriesField: amountOfSeries,
        _seriesDistanceInMetersField: seriesDistanceInMeters,
        _walkingDistanceInMetersField: walkingDistanceInMeters,
        _joggingDistanceInMetersField: joggingDistanceInMeters,
      };
}

class WorkoutStageBaseRunDto extends _DistanceWorkout {
  const WorkoutStageBaseRunDto({
    required super.distanceInKilometers,
    required super.maxHeartRate,
  }) : super(nameField: 'baseRun');

  WorkoutStageBaseRunDto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKilometers:
              (json[_distanceInKilometersField] as num).toDouble(),
          maxHeartRate: json[_maxHeartRateField],
        );
}

class WorkoutStageZone2Dto extends _DistanceWorkout {
  const WorkoutStageZone2Dto({
    required super.distanceInKilometers,
    required super.maxHeartRate,
  }) : super(nameField: 'zone2');

  WorkoutStageZone2Dto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKilometers:
              (json[_distanceInKilometersField] as num).toDouble(),
          maxHeartRate: json[_maxHeartRateField],
        );
}

class WorkoutStageZone3Dto extends _DistanceWorkout {
  const WorkoutStageZone3Dto({
    required super.distanceInKilometers,
    required super.maxHeartRate,
  }) : super(nameField: 'zone3');

  WorkoutStageZone3Dto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKilometers:
              (json[_distanceInKilometersField] as num).toDouble(),
          maxHeartRate: json[_maxHeartRateField],
        );
}

class WorkoutStageHillRepeatsDto extends _SeriesWorkout {
  const WorkoutStageHillRepeatsDto({
    required super.amountOfSeries,
    required super.seriesDistanceInMeters,
    required super.walkingDistanceInMeters,
    required super.joggingDistanceInMeters,
  }) : super(nameField: 'hillRepeats');

  WorkoutStageHillRepeatsDto.fromJson(Map<String, dynamic> json)
      : this(
          amountOfSeries: json[_amountOfSeriesField],
          seriesDistanceInMeters: json[_seriesDistanceInMetersField],
          walkingDistanceInMeters: json[_walkingDistanceInMetersField],
          joggingDistanceInMeters: json[_joggingDistanceInMetersField],
        );
}

class WorkoutStageRhythmsDto extends _SeriesWorkout {
  const WorkoutStageRhythmsDto({
    required super.amountOfSeries,
    required super.seriesDistanceInMeters,
    required super.walkingDistanceInMeters,
    required super.joggingDistanceInMeters,
  }) : super(nameField: 'rhythms');

  WorkoutStageRhythmsDto.fromJson(Map<String, dynamic> json)
      : this(
          amountOfSeries: json[_amountOfSeriesField],
          seriesDistanceInMeters: json[_seriesDistanceInMetersField],
          walkingDistanceInMeters: json[_walkingDistanceInMetersField],
          joggingDistanceInMeters: json[_joggingDistanceInMetersField],
        );
}

const String _nameField = 'name';
const String _distanceInKilometersField = 'distanceInKilometers';
const String _maxHeartRateField = 'maxHeartRate';
const String _amountOfSeriesField = 'amountOfSeries';
const String _seriesDistanceInMetersField = 'seriesDistanceInMeters';
const String _walkingDistanceInMetersField = 'walkingDistanceInMeters';
const String _joggingDistanceInMetersField = 'joggingDistanceInMeters';
