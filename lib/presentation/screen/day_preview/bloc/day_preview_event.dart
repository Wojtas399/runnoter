import 'package:equatable/equatable.dart';

abstract class DayPreviewEvent extends Equatable {
  const DayPreviewEvent();

  @override
  List<Object> get props => [];
}

class DayPreviewEventInitialize extends DayPreviewEvent {
  const DayPreviewEventInitialize();
}
