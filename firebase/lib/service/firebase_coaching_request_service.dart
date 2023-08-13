import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../model/coaching_request_dto.dart';

class FirebaseCoachingRequestService {
  Stream<List<CoachingRequestDto>> getCoachingRequestsBySenderId({
    required String senderId,
  }) =>
      getCoachingRequestsRef()
          .where(senderIdField, isEqualTo: senderId)
          .snapshots()
          .map((snapshots) => snapshots.docs)
          .map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );

  Stream<List<CoachingRequestDto>> getCoachingRequestsByReceiverId({
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

  Future<void> deleteAcceptedCoachingRequestsBySenderId({
    required String senderId,
  }) async {
    final snapshot = await getCoachingRequestsRef()
        .where(senderIdField, isEqualTo: senderId)
        .where(isAcceptedField, isEqualTo: true)
        .get();
    final batch = FirebaseFirestore.instance.batch();
    for (final request in snapshot.docs) {
      batch.delete(request.reference);
    }
    await batch.commit();
  }

  Future<void> deleteUnacceptedCoachingRequestsByReceiverId({
    required String receiverId,
  }) async {
    final snapshot = await getCoachingRequestsRef()
        .where(receiverIdField, isEqualTo: receiverId)
        .where(isAcceptedField, isEqualTo: false)
        .get();
    final batch = FirebaseFirestore.instance.batch();
    for (final request in snapshot.docs) {
      batch.delete(request.reference);
    }
    await batch.commit();
  }
}
