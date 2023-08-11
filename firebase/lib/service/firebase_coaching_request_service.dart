import '../firebase_collections.dart';
import '../mapper/coatching_request_status_mapper.dart';
import '../model/coaching_request_dto.dart';

class FirebaseCoachingRequestService {
  Stream<List<CoachingRequestDto>?> getCoachingRequestsBySenderId({
    required String senderId,
  }) =>
      getCoachingRequestsRef()
          .where(senderIdField, isEqualTo: senderId)
          .snapshots()
          .map((snapshots) => snapshots.docs)
          .map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );

  Stream<List<CoachingRequestDto>?> getCoachingRequestsByReceiverId({
    required String receiverId,
  }) =>
      getCoachingRequestsRef()
          .where(receiverIdField, isEqualTo: receiverId)
          .snapshots()
          .map((snapshots) => snapshots.docs)
          .map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );

  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required CoachingRequestStatus status,
  }) async {
    final CoachingRequestDto invitationDto = CoachingRequestDto(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      status: status,
    );
    await getCoachingRequestsRef().add(invitationDto);
  }

  Future<void> updateCoachingRequestStatus({
    required String requestId,
    required CoachingRequestStatus status,
  }) async {
    await getCoachingRequestsRef().doc(requestId).update(
      {
        coachingRequestStatusField: mapCoachingRequestStatusToString(status),
      },
    );
  }

  Future<void> deleteCoachingRequest({required String requestId}) async {
    await getCoachingRequestsRef().doc(requestId).delete();
  }
}
