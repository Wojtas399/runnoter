import '../model/activity.dart';

class Race extends Activity {
  final String place;
  final double distance;
  final Duration? expectedDuration;

  const Race({
    required super.id,
    required super.userId,
    required super.name,
    required super.date,
    required super.status,
    required this.place,
    required this.distance,
    required this.expectedDuration,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        date,
        status,
        place,
        distance,
        expectedDuration,
      ];
}
