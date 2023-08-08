import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase_collections.dart';
import '../mapper/invitation_status_mapper.dart';
import '../model/invitation_dto.dart';

class FirebaseInvitationService {
  Stream<List<InvitationDto>?> getInvitationsBySenderId({
    required String senderId,
  }) {
    final querySnapshot$ = getInvitationsRef()
        .where(senderIdField, isEqualTo: senderId)
        .snapshots();
    return _mapQuerySnapshotToDto(querySnapshot$);
  }

  Stream<List<InvitationDto>?> getInvitationsByReceiverId({
    required String receiverId,
  }) {
    final querySnapshot$ = getInvitationsRef()
        .where(receiverIdField, isEqualTo: receiverId)
        .snapshots();
    return _mapQuerySnapshotToDto(querySnapshot$);
  }

  Future<void> addInvitation({
    required String senderId,
    required String receiverId,
    required InvitationStatus status,
  }) async {
    final InvitationDto invitationDto = InvitationDto(
      id: '',
      senderId: senderId,
      receiverId: receiverId,
      status: status,
    );
    await getInvitationsRef().add(invitationDto);
  }

  Future<void> updateInvitationStatus({
    required String invitationId,
    required InvitationStatus status,
  }) async {
    await getInvitationsRef().doc(invitationId).update(
      {
        invitationStatusField: mapInvitationStatusToString(status),
      },
    );
  }

  Future<void> deleteInvitation({required String invitationId}) async {
    await getInvitationsRef().doc(invitationId).delete();
  }

  Stream<List<InvitationDto>?> _mapQuerySnapshotToDto(
    Stream<QuerySnapshot<InvitationDto>> querySnapshot$,
  ) =>
      querySnapshot$.map((snapshots) => snapshots.docs).map(
            (docs) => docs.map((docSnapshot) => docSnapshot.data()).toList(),
          );
}
