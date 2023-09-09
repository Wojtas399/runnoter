part of 'blood_test_preview_cubit.dart';

class BloodTestPreviewState extends Equatable {
  final DateTime? date;
  final Gender? gender;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestPreviewState({
    this.date,
    this.gender,
    this.parameterResults,
  });

  @override
  List<Object?> get props => [
        date,
        gender,
        parameterResults,
      ];

  BloodTestPreviewState copyWith({
    DateTime? date,
    Gender? gender,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        date: date ?? this.date,
        gender: gender ?? this.gender,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
