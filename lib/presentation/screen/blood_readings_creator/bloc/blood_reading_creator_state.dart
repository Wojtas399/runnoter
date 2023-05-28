part of 'blood_reading_creator_bloc.dart';

class BloodReadingCreatorState extends BlocState<BloodReadingCreatorState> {
  final DateTime? date;
  final List<BloodReadingParameter>? bloodReadingParameters;

  const BloodReadingCreatorState({
    required super.status,
    this.date,
    this.bloodReadingParameters,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        bloodReadingParameters,
      ];

  bool get areDataValid =>
      date != null &&
      bloodReadingParameters != null &&
      bloodReadingParameters?.isEmpty == false;

  @override
  BloodReadingCreatorState copyWith({
    BlocStatus? status,
    DateTime? date,
    List<BloodReadingParameter>? bloodReadingParameters,
  }) =>
      BloodReadingCreatorState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        bloodReadingParameters:
            bloodReadingParameters ?? this.bloodReadingParameters,
      );
}
