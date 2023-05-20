part of 'blood_test_creator_bloc.dart';

class BloodTestCreatorState extends BlocState<BloodTestCreatorState> {
  final List<BloodTestParameter>? parameters;

  const BloodTestCreatorState({
    required super.status,
    this.parameters,
  });

  @override
  List<Object?> get props => [
        status,
        parameters,
      ];

  @override
  BloodTestCreatorState copyWith({
    BlocStatus? status,
    List<BloodTestParameter>? parameters,
  }) =>
      BloodTestCreatorState(
        status: status ?? const BlocStatusComplete(),
        parameters: parameters ?? this.parameters,
      );
}
