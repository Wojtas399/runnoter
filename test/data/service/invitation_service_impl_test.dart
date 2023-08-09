import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/invitation_service_impl.dart';
import 'package:runnoter/domain/additional_model/invitation.dart';
import 'package:runnoter/domain/service/invitation_service.dart';

import '../../mock/firebase/mock_firebase_invitation_service.dart';

void main() {
  final firebaseInvitationService = MockFirebaseInvitationService();
  late InvitationService service;

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseInvitationService>(
      () => firebaseInvitationService,
    );
    service = InvitationServiceImpl();
  });

  tearDown(() {
    reset(firebaseInvitationService);
  });

  test(
    'get invitations by sender id, '
    'should emit stream from firebase invitation service to get invitations by sender id',
    () {
      const String senderId = 'u1';
      const List<firebase.InvitationDto> invitationDtos = [
        firebase.InvitationDto(
          id: 'i1',
          senderId: senderId,
          receiverId: 'u2',
          status: firebase.InvitationStatus.pending,
        ),
        firebase.InvitationDto(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          status: firebase.InvitationStatus.accepted,
        ),
        firebase.InvitationDto(
          id: 'i3',
          senderId: senderId,
          receiverId: 'u4',
          status: firebase.InvitationStatus.discarded,
        ),
      ];
      const List<Invitation> expectedInvitations = [
        Invitation(
          id: 'i1',
          senderId: senderId,
          receiverId: 'u2',
          status: InvitationStatus.pending,
        ),
        Invitation(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          status: InvitationStatus.accepted,
        ),
        Invitation(
          id: 'i3',
          senderId: senderId,
          receiverId: 'u4',
          status: InvitationStatus.discarded,
        ),
      ];
      firebaseInvitationService.mockGetInvitationsBySenderId(
        invitations: invitationDtos,
      );

      final Stream<List<Invitation>?> invitations$ =
          service.getInvitationsBySenderId(senderId: senderId);

      expect(
        invitations$,
        emitsInOrder([expectedInvitations]),
      );
    },
  );

  test(
    'get invitations by receiver id, '
    'should emit stream from firebase invitation service to get invitations by receiver id',
    () {
      const String receiverId = 'u1';
      const List<firebase.InvitationDto> invitationDtos = [
        firebase.InvitationDto(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          status: firebase.InvitationStatus.pending,
        ),
        firebase.InvitationDto(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          status: firebase.InvitationStatus.accepted,
        ),
        firebase.InvitationDto(
          id: 'i3',
          senderId: 'u4',
          receiverId: receiverId,
          status: firebase.InvitationStatus.discarded,
        ),
      ];
      const List<Invitation> expectedInvitations = [
        Invitation(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          status: InvitationStatus.pending,
        ),
        Invitation(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          status: InvitationStatus.accepted,
        ),
        Invitation(
          id: 'i3',
          senderId: 'u4',
          receiverId: receiverId,
          status: InvitationStatus.discarded,
        ),
      ];
      firebaseInvitationService.mockGetInvitationsByReceiverId(
        invitations: invitationDtos,
      );

      final Stream<List<Invitation>?> invitations$ =
          service.getInvitationsByReceiverId(receiverId: receiverId);

      expect(
        invitations$,
        emitsInOrder([expectedInvitations]),
      );
    },
  );

  test(
    'add invitation, '
    "should call firebase invitation service's method to add invitation",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      firebaseInvitationService.mockAddInvitation();

      await service.addInvitation(
        senderId: senderId,
        receiverId: receiverId,
        status: InvitationStatus.pending,
      );

      verify(
        () => firebaseInvitationService.addInvitation(
          senderId: senderId,
          receiverId: receiverId,
          status: firebase.InvitationStatus.pending,
        ),
      ).called(1);
    },
  );

  test(
    'update invitation status, '
    "should call firebase invitation service's method to update invitation status",
    () async {
      const String invitationId = 'i1';
      firebaseInvitationService.mockUpdateInvitationStatus();

      await service.updateInvitationStatus(
        invitationId: invitationId,
        status: InvitationStatus.discarded,
      );

      verify(
        () => firebaseInvitationService.updateInvitationStatus(
          invitationId: invitationId,
          status: firebase.InvitationStatus.discarded,
        ),
      ).called(1);
    },
  );

  test(
    'delete invitation, '
    "should call firebase invitation service's method to delete invitation",
    () async {
      const String invitationId = 'i1';
      firebaseInvitationService.mockDeleteInvitation();

      await service.deleteInvitation(invitationId: invitationId);

      verify(
        () => firebaseInvitationService.deleteInvitation(
          invitationId: invitationId,
        ),
      ).called(1);
    },
  );
}
