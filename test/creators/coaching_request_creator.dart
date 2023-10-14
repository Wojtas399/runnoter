import 'package:runnoter/data/additional_model/coaching_request.dart';

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
