part of 'race_preview_bloc.dart';

abstract class RacePreviewEvent {
  const RacePreviewEvent();
}

class RacePreviewEventInitialize extends RacePreviewEvent {
  const RacePreviewEventInitialize();
}

class RacePreviewEventDeleteRace extends RacePreviewEvent {
  const RacePreviewEventDeleteRace();
}
