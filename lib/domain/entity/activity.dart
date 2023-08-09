import '../additional_model/run_status.dart';
import 'entity.dart';

abstract class Activity extends Entity {
  final String userId;
  final DateTime date;
  final String name;
  final RunStatus status;

  const Activity({
    required super.id,
    required this.userId,
    required this.date,
    required this.name,
    required this.status,
  });

  double get coveredDistance {
    final RunStatus status = this.status;
    return status is RunStatusWithParams ? status.coveredDistanceInKm : 0.0;
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        name,
        status,
      ];
}
