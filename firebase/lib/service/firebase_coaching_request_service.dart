import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/coatching_request_status_mapper.dart';
import '../model/coaching_request_dto.dart';

class FirebaseCoachingRequestService {
  Stream<List<CoachingRequestDto>?> getCoachingRequestsBySenderId({
    required String senderId,
  }) {
    final querySnapshot$ = getCoachingRequestsRef()
        .where(senderIdField, isEqualTo: senderId)
        .snapshots();
    return _mapQuerySnapshotToDto(querySnapshot$);
  }

  Stream<List<CoachingRequestDto>?> getCoachingRequestsByReceiverId({
    required String receiverId,
  }) {
    final querySnapshot$ = getCoachingRequestsRef()
        .where(receiverIdField, isEqualTo: receiverId)
        .snapshots();
    return _mapQuerySnapshotToDto(querySnapshot$);
  }

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

  Stream<List<CoachingRequestDto>?> _mapQuerySnapshotToDto(
    Stream<QuerySnapshot<CoachingRequestDto>> querySnapshot$,
  ) =>
      querySnapshot$.map((snapshots) => snapshots.docs).map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );
}
