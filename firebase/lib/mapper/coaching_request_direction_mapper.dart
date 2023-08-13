import '../model/coaching_request_dto.dart';

CoachingRequestDirection mapCoachingRequestDirectionFromString(
  String directionStr,
) =>
    CoachingRequestDirection.values.byName(directionStr);

String mapCoachingRequestDirectionToString(
  CoachingRequestDirection direction,
) =>
    direction.name;
