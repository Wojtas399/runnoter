import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/coaching_request_service_impl.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';

import '../../mock/firebase/mock_firebase_invitation_service.dart';

void main() {
  final firebaseInvitationService = MockFirebaseInvitationService();
  late CoachingRequestServiceImpl service;

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseInvitationService>(
      () => firebaseInvitationService,
    );
    service = CoachingRequestServiceImpl();
  });

  tearDown(() {
    reset(firebaseInvitationService);
  });

  test(
    'get coaching requests by sender id, '
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
      const List<CoachingRequest> expectedCoachingRequests = [
        CoachingRequest(
          id: 'i1',
          senderId: senderId,
          receiverId: 'u2',
          status: CoachingRequestStatus.pending,
        ),
        CoachingRequest(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          status: CoachingRequestStatus.accepted,
        ),
        CoachingRequest(
          id: 'i3',
          senderId: senderId,
          receiverId: 'u4',
          status: CoachingRequestStatus.declined,
        ),
      ];
      firebaseInvitationService.mockGetInvitationsBySenderId(
        invitations: invitationDtos,
      );

      final Stream<List<CoachingRequest>?> coachingRequests$ =
          service.getCoachingRequestsBySenderId(senderId: senderId);

      expect(
        coachingRequests$,
        emitsInOrder([expectedCoachingRequests]),
      );
    },
  );

  test(
    'get coaching requests by receiver id, '
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
      const List<CoachingRequest> expectedCoachingRequests = [
        CoachingRequest(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          status: CoachingRequestStatus.pending,
        ),
        CoachingRequest(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          status: CoachingRequestStatus.accepted,
        ),
        CoachingRequest(
          id: 'i3',
          senderId: 'u4',
          receiverId: receiverId,
          status: CoachingRequestStatus.declined,
        ),
      ];
      firebaseInvitationService.mockGetInvitationsByReceiverId(
        invitations: invitationDtos,
      );

      final Stream<List<CoachingRequest>?> coachingRequests$ =
          service.getCoachingRequestsByReceiverId(receiverId: receiverId);

      expect(
        coachingRequests$,
        emitsInOrder([expectedCoachingRequests]),
      );
    },
  );

  test(
    'add coaching request, '
    "should call firebase invitation service's method to add invitation",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      firebaseInvitationService.mockAddInvitation();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        status: CoachingRequestStatus.pending,
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
    'update coaching request status, '
    "should call firebase invitation service's method to update invitation status",
    () async {
      const String requestId = 'i1';
      firebaseInvitationService.mockUpdateInvitationStatus();

      await service.updateCoachingRequestStatus(
        requestId: requestId,
        status: CoachingRequestStatus.declined,
      );

      verify(
        () => firebaseInvitationService.updateInvitationStatus(
          invitationId: requestId,
          status: firebase.InvitationStatus.discarded,
        ),
      ).called(1);
    },
  );

  test(
    'delete coaching request, '
    "should call firebase invitation service's method to delete invitation",
    () async {
      const String requestId = 'i1';
      firebaseInvitationService.mockDeleteInvitation();

      await service.deleteCoachingRequest(requestId: requestId);

      verify(
        () => firebaseInvitationService.deleteInvitation(
          invitationId: requestId,
        ),
      ).called(1);
    },
  );
}
