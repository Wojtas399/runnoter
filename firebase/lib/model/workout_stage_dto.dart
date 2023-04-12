part of firebase;

class WorkoutStageDto extends Equatable {
  const WorkoutStageDto();

  factory WorkoutStageDto.fromJson(Map<String, dynamic> json) {
    final String stageType = json[_typeField];
    if (stageType == 'owb') {
      return WorkoutStageOWBDto.fromJson(json);
    } else if (stageType == 'bc2') {
      return WorkoutStageBC2Dto.fromJson(json);
    } else if (stageType == 'bc3') {
      return WorkoutStageBC3Dto.fromJson(json);
    } else if (stageType == 'strength') {
      return WorkoutStageStrengthDto.fromJson(json);
    } else if (stageType == 'rhythms') {
      return WorkoutStageRhythmsDto.fromJson(json);
    } else {
      throw '[WorkoutStageDto] Unknown stage type';
    }
  }

  @override
  List<Object> get props => [];

  Map<String, dynamic> toJson() => {};
}

class WorkoutStageOWBDto extends WorkoutStageDto {
  final double distanceInKm;
  final int maxHeartRate;

  const WorkoutStageOWBDto({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  WorkoutStageOWBDto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKm: json[_distanceInKmField],
          maxHeartRate: json[_maxHeartRateField],
        );

  @override
  List<Object> get props => [
        distanceInKm,
        maxHeartRate,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _typeField: 'owb',
        _distanceInKmField: distanceInKm,
        _maxHeartRateField: maxHeartRate,
      };
}

class WorkoutStageBC2Dto extends WorkoutStageDto {
  final double distanceInKm;
  final int maxHeartRate;

  const WorkoutStageBC2Dto({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  WorkoutStageBC2Dto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKm: json[_distanceInKmField],
          maxHeartRate: json[_maxHeartRateField],
        );

  @override
  List<Object> get props => [
        distanceInKm,
        maxHeartRate,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _typeField: 'bc2',
        _distanceInKmField: distanceInKm,
        _maxHeartRateField: maxHeartRate,
      };
}

class WorkoutStageBC3Dto extends WorkoutStageDto {
  final double distanceInKm;
  final int maxHeartRate;

  const WorkoutStageBC3Dto({
    required this.distanceInKm,
    required this.maxHeartRate,
  });

  WorkoutStageBC3Dto.fromJson(Map<String, dynamic> json)
      : this(
          distanceInKm: json[_distanceInKmField],
          maxHeartRate: json[_maxHeartRateField],
        );

  @override
  List<Object> get props => [
        distanceInKm,
        maxHeartRate,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _typeField: 'bc3',
        _distanceInKmField: distanceInKm,
        _maxHeartRateField: maxHeartRate,
      };
}

class WorkoutStageStrengthDto extends WorkoutStageDto {
  final int amountOfSeries;
  final int seriesDistanceInMeters;
  final int breakMarchDistanceInMeters;
  final int breakJogDistanceInMeters;

  const WorkoutStageStrengthDto({
    required this.amountOfSeries,
    required this.seriesDistanceInMeters,
    required this.breakMarchDistanceInMeters,
    required this.breakJogDistanceInMeters,
  });

  WorkoutStageStrengthDto.fromJson(Map<String, dynamic> json)
      : this(
          amountOfSeries: json[_amountOfSeriesField],
          seriesDistanceInMeters: json[_seriesDistanceInMetersField],
          breakMarchDistanceInMeters: json[_breakMarchDistanceInMetersField],
          breakJogDistanceInMeters: json[_breakJogDistanceInMetersField],
        );

  @override
  List<Object> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        breakMarchDistanceInMeters,
        breakJogDistanceInMeters,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _typeField: 'strength',
        _amountOfSeriesField: amountOfSeries,
        _seriesDistanceInMetersField: seriesDistanceInMeters,
        _breakMarchDistanceInMetersField: breakMarchDistanceInMeters,
        _breakJogDistanceInMetersField: breakJogDistanceInMeters,
      };
}

class WorkoutStageRhythmsDto extends WorkoutStageDto {
  final int amountOfSeries;
  final int seriesDistanceInMeters;
  final int breakMarchDistanceInMeters;
  final int breakJogDistanceInMeters;

  const WorkoutStageRhythmsDto({
    required this.amountOfSeries,
    required this.seriesDistanceInMeters,
    required this.breakMarchDistanceInMeters,
    required this.breakJogDistanceInMeters,
  });

  WorkoutStageRhythmsDto.fromJson(Map<String, dynamic> json)
      : this(
          amountOfSeries: json[_amountOfSeriesField],
          seriesDistanceInMeters: json[_seriesDistanceInMetersField],
          breakMarchDistanceInMeters: json[_breakMarchDistanceInMetersField],
          breakJogDistanceInMeters: json[_breakJogDistanceInMetersField],
        );

  @override
  List<Object> get props => [
        amountOfSeries,
        seriesDistanceInMeters,
        breakMarchDistanceInMeters,
        breakJogDistanceInMeters,
      ];

  @override
  Map<String, dynamic> toJson() => {
        _typeField: 'rhythms',
        _amountOfSeriesField: amountOfSeries,
        _seriesDistanceInMetersField: seriesDistanceInMeters,
        _breakMarchDistanceInMetersField: breakMarchDistanceInMeters,
        _breakJogDistanceInMetersField: breakJogDistanceInMeters,
      };
}

const String _typeField = 'type';
const String _distanceInKmField = 'distanceInKm';
const String _maxHeartRateField = 'maxHeartRate';
const String _amountOfSeriesField = 'amountOfSeries';
const String _seriesDistanceInMetersField = 'seriesDistanceInMeters';
const String _breakMarchDistanceInMetersField = 'breakMarchDistanceInMeters';
const String _breakJogDistanceInMetersField = 'breakJogDistanceInMeters';
