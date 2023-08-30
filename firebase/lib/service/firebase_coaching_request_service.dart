import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/coaching_request_direction_mapper.dart';
import '../model/coaching_request_dto.dart';

class FirebaseCoachingRequestService {
  Stream<List<CoachingRequestDto>> getCoachingRequestsBySenderId({
    required String senderId,
    required CoachingRequestDirection direction,
  }) =>
      getCoachingRequestsRef()
          .where(senderIdField, isEqualTo: senderId)
          .where(
            directionField,
            isEqualTo: mapCoachingRequestDirectionToString(direction),
          )
          .snapshots()
          .map((snapshots) => snapshots.docs)
          .map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );

  Stream<List<CoachingRequestDto>> getCoachingRequestsByReceiverId({
    required String receiverId,
    required CoachingRequestDirection direction,
  }) =>
      getCoachingRequestsRef()
          .where(receiverIdField, isEqualTo: receiverId)
          .where(
            directionField,
            isEqualTo: mapCoachingRequestDirectionToString(direction),
          )
          .snapshots()
          .map((snapshots) => snapshots.docs)
          .map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );

  Future<void> addCoachingRequest({
    required String senderId,
    required String receiverId,
    required CoachingRequestDirection direction,
    required bool isAccepted,
  }) async {
    final CoachingRequestDto invitationDto = CoachingRequestDto(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      direction: direction,
      isAccepted: isAccepted,
    );
    await getCoachingRequestsRef().add(invitationDto);
  }

  Future<void> updateCoachingRequest({
    required String requestId,
    required bool isAccepted,
  }) async {
    await getCoachingRequestsRef().doc(requestId).update(
      {
        isAcceptedField: isAccepted,
      },
    );
  }

  Future<void> deleteCoachingRequest({required String requestId}) async {
    await getCoachingRequestsRef().doc(requestId).delete();
  }

  Future<void> deleteCoachingRequestsByUserId({required String userId}) async {
    final batch = FirebaseFirestore.instance.batch();
    final requestsRef = getCoachingRequestsRef();
    final sentRequestsSnapshot =
        await requestsRef.where(senderIdField, isEqualTo: userId).get();
    final receivedRequestsSnapshot =
        await requestsRef.where(receiverIdField, isEqualTo: userId).get();
    for (final request in sentRequestsSnapshot.docs) {
      batch.delete(request.reference);
    }
    for (final request in receivedRequestsSnapshot.docs) {
      batch.delete(request.reference);
    }
    await batch.commit();
  }
}
