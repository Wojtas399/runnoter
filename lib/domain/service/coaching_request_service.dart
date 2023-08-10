import '../additional_model/coaching_request.dart';

abstract interface class CoachingRequestService {
  Stream<List<CoachingRequest>?> getCoachingRequestsBySenderId({
    required String senderId,
  });

  Stream<List<CoachingRequest>?> getCoachingRequestsByReceiverId({
    required String receiverId,
  });

  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required CoachingRequestStatus status,
  });

  Future<void> updateCoachingRequestStatus({
    required String requestId,
    required CoachingRequestStatus status,
  });

  Future<void> deleteCoachingRequest({required String requestId});
}
