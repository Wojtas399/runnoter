part of 'blood_test_preview_bloc.dart';

class BloodTestPreviewState extends BlocState<BloodTestPreviewState> {
  final String? bloodTestId;
  final DateTime? date;
  final List<BloodParameterResult>? parameterResults;

  const BloodTestPreviewState({
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

  @override
  BloodTestPreviewState copyWith({
    BlocStatus? status,
    String? bloodTestId,
    DateTime? date,
    List<BloodParameterResult>? parameterResults,
  }) =>
      BloodTestPreviewState(
        status: status ?? const BlocStatusComplete(),
        bloodTestId: bloodTestId ?? this.bloodTestId,
        date: date ?? this.date,
        parameterResults: parameterResults ?? this.parameterResults,
      );
}
