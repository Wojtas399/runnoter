import 'entity.dart';
import 'run_status.dart';

class Competition extends Entity {
  final String userId;
  final String name;
  final DateTime date;
  final String place;
  final double distance;
  final Duration? expectedDuration;
  final RunStatus status;

  const Competition({
    required super.id,
    required this.userId,
    required this.name,
    required this.date,
    required this.place,
    required this.distance,
    required this.expectedDuration,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        date,
        place,
        distance,
        expectedDuration,
        status,
      ];
}
