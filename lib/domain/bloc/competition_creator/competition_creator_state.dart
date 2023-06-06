import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../entity/competition.dart';

class CompetitionCreatorState extends BlocState<CompetitionCreatorState> {
  final String? name;
  final DateTime? date;
  final String? place;
  final double? distance;
  final Time? expectedTime;

  const CompetitionCreatorState({
    required super.status,
    this.name,
    this.date,
    this.place,
    this.distance,
    this.expectedTime,
  });

  @override
  List<Object?> get props => [
        status,
        name,
        date,
        place,
        distance,
        expectedTime,
      ];

  bool get areDataValid =>
      name != null &&
      name!.isNotEmpty &&
      date != null &&
      place != null &&
      place!.isNotEmpty &&
      distance != null &&
      distance! > 0 &&
      expectedTime != null;

  @override
  CompetitionCreatorState copyWith({
    BlocStatus? status,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Time? expectedTime,
  }) =>
      CompetitionCreatorState(
        status: status ?? const BlocStatusComplete(),
        name: name ?? this.name,
        date: date ?? this.date,
        place: place ?? this.place,
        distance: distance ?? this.distance,
        expectedTime: expectedTime ?? this.expectedTime,
      );
}
