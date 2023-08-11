import 'package:runnoter/domain/additional_model/coaching_request.dart';

CoachingRequest createCoachingRequest({
  String id = '',
  String senderId = '',
  String receiverId = '',
  bool isAccepted = false,
}) =>
    CoachingRequest(
      id: id,
      senderId: senderId,
      receiverId: receiverId,
      isAccepted: isAccepted,
    );
