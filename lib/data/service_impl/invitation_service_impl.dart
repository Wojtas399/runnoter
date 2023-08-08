import '../../domain/entity/invitation.dart';
import '../../domain/service/invitation_service.dart';

class InvitationServiceImpl implements InvitationService {
  @override
  Stream<List<Invitation>?> getInvitationsBySenderId({
    required String senderId,
  }) {
    // TODO: implement getInvitationsBySenderId
    throw UnimplementedError();
  }

  @override
  Stream<List<Invitation>?> getInvitationsByReceiverId({
    required String receiverId,
  }) {
    // TODO: implement getInvitationsByReceiverId
    throw UnimplementedError();
  }

  @override
  Future<void> sendInvitation({
    required String senderId,
    required String receiverId,
  }) {
    // TODO: implement sendInvitation
    throw UnimplementedError();
  }

  @override
  Future<void> updateInvitationStatus({
    required String invitationId,
    required InvitationStatus status,
  }) {
    // TODO: implement updateInvitationStatus
    throw UnimplementedError();
  }

  @override
  Future<void> deleteInvitation({required String invitationId}) {
    // TODO: implement deleteInvitation
    throw UnimplementedError();
  }
}
