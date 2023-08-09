import '../additional_model/invitation.dart';

abstract interface class InvitationService {
  Stream<List<Invitation>?> getInvitationsBySenderId({
    required String senderId,
  });

  Stream<List<Invitation>?> getInvitationsByReceiverId({
    required String receiverId,
  });

  Future<void> addInvitation({
    required String senderId,
    required String receiverId,
    required InvitationStatus status,
  });

  Future<void> updateInvitationStatus({
    required String invitationId,
    required InvitationStatus status,
  });

  Future<void> deleteInvitation({required String invitationId});
}
