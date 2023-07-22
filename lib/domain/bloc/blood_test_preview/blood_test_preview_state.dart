part of 'blood_test_preview_bloc.dart';

class BloodTestPreviewState extends BlocState<BloodTestPreviewState> {
  final DateTime? date;
  final Gender? gender;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestPreviewState({
    required super.status,
    this.date,
    this.gender,
    this.parameterResults,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        gender,
        parameterResults,
      ];

  @override
  BloodTestPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    Gender? gender,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        gender: gender ?? this.gender,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
