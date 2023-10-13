import '../../domain/additional_model/activity_status.dart';
import '../../domain/entity/entity.dart';

abstract class Activity extends Entity {
  final String userId;
  final DateTime date;
  final String name;
  final ActivityStatus status;

  const Activity({
    required super.id,
    required this.userId,
    required this.date,
    required this.name,
    required this.status,
  });

  double get coveredDistance {
    final ActivityStatus status = this.status;
    return status is ActivityStatusWithParams
        ? status.coveredDistanceInKm
        : 0.0;
  }

  @override
  List<Object?> get props => [id, userId, date, name, status];
}
