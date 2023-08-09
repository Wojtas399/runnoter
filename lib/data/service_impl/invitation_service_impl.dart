import 'package:firebase/firebase.dart' as firebase;

import '../../dependency_injection.dart';
import '../../domain/additional_model/invitation.dart';
import '../../domain/service/invitation_service.dart';
import '../mapper/invitation_mapper.dart';
import '../mapper/invitation_status_mapper.dart';

class InvitationServiceImpl implements InvitationService {
  final firebase.FirebaseInvitationService _firebaseInvitationService;

  InvitationServiceImpl()
      : _firebaseInvitationService =
            getIt<firebase.FirebaseInvitationService>();

  @override
  Stream<List<Invitation>?> getInvitationsBySenderId({
    required String senderId,
  }) =>
      _firebaseInvitationService
          .getInvitationsBySenderId(senderId: senderId)
          .map(
            (invitationDtos) =>
                invitationDtos?.map(mapInvitationFromDto).toList(),
          );

  @override
  Stream<List<Invitation>?> getInvitationsByReceiverId({
    required String receiverId,
  }) =>
      _firebaseInvitationService
          .getInvitationsByReceiverId(receiverId: receiverId)
          .map(
            (invitationDtos) =>
                invitationDtos?.map(mapInvitationFromDto).toList(),
          );

  @override
  Future<void> addInvitation({
    required String senderId,
    required String receiverId,
    required InvitationStatus status,
  }) async {
    await _firebaseInvitationService.addInvitation(
      senderId: senderId,
      receiverId: receiverId,
      status: mapInvitationStatusToDto(status),
    );
  }

  @override
  Future<void> updateInvitationStatus({
    required String invitationId,
    required InvitationStatus status,
  }) async {
    await _firebaseInvitationService.updateInvitationStatus(
      invitationId: invitationId,
      status: mapInvitationStatusToDto(status),
    );
  }

  @override
  Future<void> deleteInvitation({required String invitationId}) async {
    await _firebaseInvitationService.deleteInvitation(
      invitationId: invitationId,
    );
  }
}
