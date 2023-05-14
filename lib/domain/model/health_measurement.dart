import 'entity.dart';

class HealthMeasurement extends Entity {
  final String userId;
  final DateTime date;
  final int restingHeartRate;
  final double fastingWeight;

  HealthMeasurement({
    required this.userId,
    required this.date,
    required this.restingHeartRate,
    required this.fastingWeight,
  }) : super(
          id: '${date.year}-${date.month}-${date.day}',
        );

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        restingHeartRate,
        fastingWeight,
      ];
}
