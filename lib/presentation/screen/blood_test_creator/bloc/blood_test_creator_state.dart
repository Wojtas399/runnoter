part of 'blood_test_creator_bloc.dart';

class BloodTestCreatorState extends BlocState<BloodTestCreatorState> {
  final String? bloodTestId;
  final DateTime? date;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestCreatorState({
    required super.status,
    this.bloodTestId,
    this.date,
    this.parameterResults,
  });

  @override
  List<Object?> get props => [
        status,
        bloodTestId,
        date,
        parameterResults,
      ];

  bool get areDataValid =>
      date != null &&
      parameterResults != null &&
      parameterResults?.isEmpty == false;

  @override
  BloodTestCreatorState copyWith({
    BlocStatus? status,
    String? bloodTestId,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestCreatorState(
        status: status ?? const BlocStatusComplete(),
        bloodTestId: bloodTestId ?? this.bloodTestId,
        date: date ?? this.date,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
