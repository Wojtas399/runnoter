part of 'competition_creator_bloc.dart';

class CompetitionCreatorState extends BlocState<CompetitionCreatorState> {
  final Competition? competition;
  final String? name;
  final DateTime? date;
  final String? place;
  final double? distance;
  final Duration? expectedDuration;

  const CompetitionCreatorState({
    required super.status,
    this.competition,
    this.name,
    this.date,
    this.place,
    this.distance,
    this.expectedDuration,
  });

  @override
  List<Object?> get props => [
        status,
        competition,
        name,
        date,
        place,
        distance,
        expectedDuration,
      ];

  bool get areDataValid =>
      name != null &&
      name!.isNotEmpty &&
      date != null &&
      place != null &&
      place!.isNotEmpty &&
      distance != null &&
      distance! > 0;

  bool get areDataSameAsOriginal =>
      name == competition?.name &&
      (date != null &&
          competition?.date != null &&
          date!.isAtSameMomentAs(competition!.date)) &&
      place == competition?.place &&
      distance == competition?.distance &&
      (expectedDuration == competition?.expectedDuration ||
          (expectedDuration?.inSeconds == 0 &&
              competition?.expectedDuration == null));

  @override
  CompetitionCreatorState copyWith({
    BlocStatus? status,
    Competition? competition,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      CompetitionCreatorState(
        status: status ?? const BlocStatusComplete(),
        competition: competition ?? this.competition,
        name: name ?? this.name,
        date: date ?? this.date,
        place: place ?? this.place,
        distance: distance ?? this.distance,
        expectedDuration: expectedDuration ?? this.expectedDuration,
      );
}
