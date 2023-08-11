import '../additional_model/coaching_request.dart';

abstract interface class CoachingRequestService {
  Stream<List<CoachingRequest>> getCoachingRequestsBySenderId({
    required String senderId,
  });

  Stream<List<CoachingRequest>> getCoachingRequestsByReceiverId({
    required String receiverId,
  });

  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required bool isAccepted,
  });

  Future<void> updateCoachingRequest({
    required String requestId,
    required bool isAccepted,
  });

  Future<void> deleteCoachingRequest({required String requestId});
}
