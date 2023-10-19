import 'package:runnoter/data/service/coaching_request/coaching_request_service.dart';

CoachingRequest createCoachingRequest({
  String id = '',
  String senderId = '',
  String receiverId = '',
  CoachingRequestDirection direction = CoachingRequestDirection.clientToCoach,
  bool isAccepted = false,
}) =>
    CoachingRequest(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      direction: direction,
      isAccepted: isAccepted,
    );
