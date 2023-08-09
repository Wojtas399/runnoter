import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/invitation.dart';
import 'package:runnoter/domain/service/invitation_service.dart';

class MockInvitationService extends Mock implements InvitationService {
  MockInvitationService() {
    registerFallbackValue(InvitationStatus.pending);
  }

  void mockGetInvitationsBySenderId({List<Invitation>? invitations}) {
    when(
      () => getInvitationsBySenderId(
        senderId: any(named: 'senderId'),
      ),
    ).thenAnswer((_) => Stream.value(invitations));
  }

  void mockGetInvitationsByReceiverId({List<Invitation>? invitations}) {
    when(
      () => getInvitationsByReceiverId(
        receiverId: any(named: 'receiverId'),
      ),
    ).thenAnswer((_) => Stream.value(invitations));
  }

  void mockAddInvitation() {
    when(
      () => addInvitation(
        senderId: any(named: 'senderId'),
        receiverId: any(named: 'receiverId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockUpdateInvitationStatus() {
    when(
      () => updateInvitationStatus(
        invitationId: any(named: 'invitationId'),
        status: any(named: 'status'),
      ),
    ).thenAnswer((_) => Future.value());
  }

  void mockDeleteInvitation() {
    when(
      () => deleteInvitation(
        invitationId: any(named: 'invitationId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
