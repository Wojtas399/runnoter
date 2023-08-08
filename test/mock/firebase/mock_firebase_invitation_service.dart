import 'package:firebase/firebase.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseInvitationService extends Mock
    implements FirebaseInvitationService {
  void mockGetInvitationsBySenderId({List<InvitationDto>? invitations}) {
    when(
      () => getInvitationsBySenderId(
        senderId: any(named: 'senderId'),
      ),
    ).thenAnswer((_) => Stream.value(invitations));
  }

  void mockGetInvitationsByReceiverId({List<InvitationDto>? invitations}) {
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
    ).thenAnswer((_) => Future.value(_));
  }

  void mockDeleteInvitation() {
    when(
      () => deleteInvitation(
        invitationId: any(named: 'invitationId'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
