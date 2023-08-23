part of 'race_preview_bloc.dart';

class RacePreviewState extends BlocState<RacePreviewState> {
  final Race? race;

  const RacePreviewState({
    required super.status,
    this.race,
  });

  @override
  List<Object?> get props => [status, race];

  @override
  RacePreviewState copyWith({
    BlocStatus? status,
    Race? race,
  }) =>
      RacePreviewState(
        status: status ?? const BlocStatusComplete(),
        race: race ?? this.race,
      );
}
