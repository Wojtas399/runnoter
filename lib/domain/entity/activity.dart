import 'entity.dart';
import 'run_status.dart';

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

  @override
  List<Object?> get props => [
        id,
        userId,
        date,
        name,
        status,
      ];
}
