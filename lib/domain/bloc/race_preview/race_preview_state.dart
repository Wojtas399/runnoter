part of 'race_preview_bloc.dart';

class RacePreviewState extends BlocState<RacePreviewState> {
  final bool canEditRaceStatus;
  final Race? race;

  const RacePreviewState({
    required super.status,
    this.canEditRaceStatus = true,
    this.race,
  });

  @override
  List<Object?> get props => [status, canEditRaceStatus, race];

  @override
  RacePreviewState copyWith({
    BlocStatus? status,
    bool? canEditRaceStatus,
    Race? race,
  }) =>
      RacePreviewState(
        status: status ?? const BlocStatusComplete(),
        canEditRaceStatus: canEditRaceStatus ?? this.canEditRaceStatus,
        race: race ?? this.race,
      );
}
