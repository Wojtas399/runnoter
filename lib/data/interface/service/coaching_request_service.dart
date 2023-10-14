import '../../additional_model/coaching_request.dart';

abstract interface class CoachingRequestService {
  Stream<List<CoachingRequest>> getCoachingRequestsBySenderId({
    required String senderId,
    required CoachingRequestDirection direction,
  });

  Stream<List<CoachingRequest>> getCoachingRequestsByReceiverId({
    required String receiverId,
    required CoachingRequestDirection direction,
  });

  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required CoachingRequestDirection direction,
    required bool isAccepted,
  });

  Future<void> updateCoachingRequest({
    required String requestId,
    required bool isAccepted,
  });

  Future<void> deleteCoachingRequest({required String requestId});

  Future<void> deleteCoachingRequestsByUserId({required String userId});

  Future<void> deleteCoachingRequestBetweenUsers({
    required String user1Id,
    required String user2Id,
  });
}
