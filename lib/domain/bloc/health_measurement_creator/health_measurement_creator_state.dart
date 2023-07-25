part of 'health_measurement_creator_bloc.dart';

class HealthMeasurementCreatorState
    extends BlocState<HealthMeasurementCreatorState> {
  final DateService _dateService;
  final HealthMeasurement? measurement;
  final DateTime? date;
  final int? restingHeartRate;
  final double? fastingWeight;

  const HealthMeasurementCreatorState({
    required DateService dateService,
    required super.status,
    this.measurement,
    this.date,
    this.restingHeartRate,
    this.fastingWeight,
  }) : _dateService = dateService;

  @override
  List<Object?> get props => [
        status,
        measurement,
        date,
        restingHeartRate,
        fastingWeight,
      ];

  bool get canSubmit =>
      _isDateValid &&
      _isRestingHeartRateValid &&
      _isFastingWeightValid &&
      _areDataDifferentThanOriginal;

  bool get _isDateValid {
    if (date == null) {
      return false;
    }
    final todayDate = _dateService.getToday();
    return date!.isBefore(todayDate) ||
        _dateService.areDatesTheSame(date!, todayDate);
  }

  bool get _isRestingHeartRateValid =>
      restingHeartRate != null && restingHeartRate! > 0;

  bool get _isFastingWeightValid => fastingWeight != null && fastingWeight! > 0;

  @override
  copyWith({
    BlocStatus? status,
    HealthMeasurement? measurement,
    DateTime? date,
    int? restingHeartRate,
    double? fastingWeight,
  }) =>
      HealthMeasurementCreatorState(
        dateService: _dateService,
        status: status ?? const BlocStatusComplete(),
        measurement: measurement ?? this.measurement,
        date: date ?? this.date,
        restingHeartRate: restingHeartRate ?? this.restingHeartRate,
        fastingWeight: fastingWeight ?? this.fastingWeight,
      );

  bool get _areDataDifferentThanOriginal {
    bool areDatesDifferent = true;
    if (date != null && measurement != null) {
      areDatesDifferent =
          !_dateService.areDatesTheSame(date!, measurement!.date);
    }
    return areDatesDifferent ||
        restingHeartRate != measurement?.restingHeartRate ||
        fastingWeight != measurement?.fastingWeight;
  }
}
