import 'entity.dart';

class MorningMeasurement extends Entity {
  final DateTime date;
  final int restingHeartRate;
  final double weight;

  MorningMeasurement({
    required this.date,
    required this.restingHeartRate,
    required this.weight,
  }) : super(
          id: '${date.year}-${date.month}-${date.day}',
        );

  @override
  List<Object?> get props => [
        id,
        restingHeartRate,
        weight,
      ];
}
