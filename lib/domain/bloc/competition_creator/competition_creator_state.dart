part of 'competition_creator_bloc.dart';

class CompetitionCreatorState extends BlocState<CompetitionCreatorState> {
  final String? name;
  final DateTime? date;
  final String? place;
  final double? distance;
  final Duration? expectedDuration;

  const CompetitionCreatorState({
    required super.status,
    this.name,
    this.date,
    this.place,
    this.distance,
    this.expectedDuration,
  });

  @override
  List<Object?> get props => [
        status,
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
      distance! > 0 &&
      expectedDuration != null;

  @override
  CompetitionCreatorState copyWith({
    BlocStatus? status,
    String? name,
    DateTime? date,
    String? place,
    double? distance,
    Duration? expectedDuration,
  }) =>
      CompetitionCreatorState(
        status: status ?? const BlocStatusComplete(),
        name: name ?? this.name,
        date: date ?? this.date,
        place: place ?? this.place,
        distance: distance ?? this.distance,
        expectedDuration: expectedDuration ?? this.expectedDuration,
      );
}
