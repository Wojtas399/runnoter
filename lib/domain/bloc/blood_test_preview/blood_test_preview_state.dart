part of 'blood_test_preview_bloc.dart';

class BloodTestPreviewState extends BlocState<BloodTestPreviewState> {
  final DateTime? date;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestPreviewState({
    required super.status,
    this.date,
    this.parameterResults,
  });

  @override
  List<Object?> get props => [
        status,
        date,
        parameterResults,
      ];

  @override
  BloodTestPreviewState copyWith({
    BlocStatus? status,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        status: status ?? const BlocStatusComplete(),
        date: date ?? this.date,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
