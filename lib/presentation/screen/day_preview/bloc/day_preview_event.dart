import 'package:equatable/equatable.dart';

abstract class DayPreviewEvent extends Equatable {
  const DayPreviewEvent();

  @override
  List<Object> get props => [];
}

class DayPreviewEventInitialize extends DayPreviewEvent {
  final DateTime date;

  const DayPreviewEventInitialize({
    required this.date,
  });

  @override
  List<Object> get props => [
        date,
      ];
}
