import '../../domain/additional_model/blood_parameter.dart';
import 'entity.dart';

class BloodTest extends Entity {
  final String userId;
  final DateTime date;
  final List<BloodParameterResult> parameterResults;

  const BloodTest({
    required super.id,
    required this.userId,
    required this.date,
    required this.parameterResults,
  }) : assert(parameterResults.length > 0);

  @override
  List<Object?> get props => [id, userId, date, parameterResults];
}
