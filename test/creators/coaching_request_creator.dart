import 'package:runnoter/domain/additional_model/coaching_request.dart';

CoachingRequest createCoachingRequest({
  String id = '',
  String senderId = '',
  String receiverId = '',
  CoachingRequestStatus status = CoachingRequestStatus.pending,
}) =>
    CoachingRequest(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      status: status,
    );
