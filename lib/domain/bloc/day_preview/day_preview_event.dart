part of 'day_preview_bloc.dart';

abstract class DayPreviewEvent {
  const DayPreviewEvent();
}

class DayPreviewEventInitialize extends DayPreviewEvent {
  const DayPreviewEventInitialize();
}

class DayPreviewEventRemoveHealthMeasurement extends DayPreviewEvent {
  const DayPreviewEventRemoveHealthMeasurement();
}
