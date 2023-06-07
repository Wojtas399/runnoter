part of 'competition_preview_bloc.dart';

class CompetitionPreviewState extends BlocState<CompetitionPreviewState> {
  final Competition? competition;

  const CompetitionPreviewState({
    required super.status,
    this.competition,
  });

  @override
  List<Object?> get props => [
        status,
        competition,
      ];

  @override
  CompetitionPreviewState copyWith({
    BlocStatus? status,
    Competition? competition,
  }) =>
      CompetitionPreviewState(
        status: status ?? const BlocStatusComplete(),
        competition: competition ?? this.competition,
      );
}
