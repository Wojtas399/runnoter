part of 'competition_preview_bloc.dart';

abstract class CompetitionPreviewEvent {
  const CompetitionPreviewEvent();
}

class CompetitionPreviewEventInitialize extends CompetitionPreviewEvent {
  final String competitionId;

  const CompetitionPreviewEventInitialize({
    required this.competitionId,
  });
}

class CompetitionPreviewEventCompetitionUpdated
    extends CompetitionPreviewEvent {
  final Competition? competition;

  const CompetitionPreviewEventCompetitionUpdated({
    required this.competition,
  });
}

class CompetitionPreviewEventDeleteCompetition extends CompetitionPreviewEvent {
  const CompetitionPreviewEventDeleteCompetition();
}
