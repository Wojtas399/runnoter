import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/service_impl/coaching_request_service_impl.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';

import '../../creators/user_dto_creator.dart';
import '../../mock/firebase/mock_firebase_coaching_request_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final firebaseCoachingRequestService = MockFirebaseCoachingRequestService();
  final firebaseUserService = MockFirebaseUserService();
  late CoachingRequestServiceImpl service;

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseCoachingRequestService>(
      () => firebaseCoachingRequestService,
    );
    GetIt.I.registerFactory<firebase.FirebaseUserService>(
      () => firebaseUserService,
    );
    service = CoachingRequestServiceImpl();
  });

  tearDown(() {
    reset(firebaseCoachingRequestService);
    reset(firebaseUserService);
  });

  test(
    'get coaching requests by sender id, '
    'should emit stream from firebase coaching request service to get coaching requests by sender id',
    () {
      const String senderId = 'u1';
      const List<firebase.CoachingRequestDto> requestDtos = [
        firebase.CoachingRequestDto(
          id: 'i1',
          senderId: senderId,
          receiverId: 'u2',
          direction: firebase.CoachingRequestDirection.clientToCoach,
          isAccepted: false,
        ),
        firebase.CoachingRequestDto(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          direction: firebase.CoachingRequestDirection.clientToCoach,
          isAccepted: true,
        ),
      ];
      const List<CoachingRequest> expectedCoachingRequests = [
        CoachingRequest(
          id: 'i1',
          senderId: senderId,
          receiverId: 'u2',
          direction: CoachingRequestDirection.clientToCoach,
          isAccepted: false,
        ),
        CoachingRequest(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          direction: CoachingRequestDirection.clientToCoach,
          isAccepted: true,
        ),
      ];
      firebaseCoachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: requestDtos,
      );

      final Stream<List<CoachingRequest>?> coachingRequests$ =
          service.getCoachingRequestsBySenderId(
        senderId: senderId,
        direction: CoachingRequestDirection.clientToCoach,
      );

      expect(
        coachingRequests$,
        emitsInOrder([expectedCoachingRequests]),
      );
      verify(
        () => firebaseCoachingRequestService.getCoachingRequestsBySenderId(
          senderId: senderId,
          direction: firebase.CoachingRequestDirection.clientToCoach,
        ),
      ).called(1);
    },
  );

  test(
    'get coaching requests by receiver id, '
    'should emit stream from firebase coaching request service to get coaching requests by receiver id',
    () {
      const String receiverId = 'u1';
      const List<firebase.CoachingRequestDto> requestDtos = [
        firebase.CoachingRequestDto(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          direction: firebase.CoachingRequestDirection.coachToClient,
          isAccepted: false,
        ),
        firebase.CoachingRequestDto(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          direction: firebase.CoachingRequestDirection.coachToClient,
          isAccepted: true,
        ),
      ];
      const List<CoachingRequest> expectedCoachingRequests = [
        CoachingRequest(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          direction: CoachingRequestDirection.coachToClient,
          isAccepted: false,
        ),
        CoachingRequest(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          direction: CoachingRequestDirection.coachToClient,
          isAccepted: true,
        ),
      ];
      firebaseCoachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: requestDtos,
      );

      final Stream<List<CoachingRequest>?> coachingRequests$ =
          service.getCoachingRequestsByReceiverId(
        receiverId: receiverId,
        direction: CoachingRequestDirection.coachToClient,
      );

      expect(
        coachingRequests$,
        emitsInOrder([expectedCoachingRequests]),
      );
      verify(
        () => firebaseCoachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: receiverId,
          direction: firebase.CoachingRequestDirection.coachToClient,
        ),
      ).called(1);
    },
  );

  test(
    'add coaching request, '
    'coach to client, '
    'receiver does not have a coach, '
    "should call firebase coaching request service's method to add coaching request",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      const bool isAccepted = false;
      firebaseUserService.mockLoadUserById(
        userDto: createUserDto(id: receiverId),
      );
      firebaseCoachingRequestService.mockAddCoachingRequest();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        direction: CoachingRequestDirection.coachToClient,
        isAccepted: isAccepted,
      );

      verify(
        () => firebaseUserService.loadUserById(userId: receiverId),
      ).called(1);
      verify(
        () => firebaseCoachingRequestService.addCoachingRequest(
          senderId: senderId,
          receiverId: receiverId,
          direction: firebase.CoachingRequestDirection.coachToClient,
          isAccepted: isAccepted,
        ),
      ).called(1);
    },
  );

  test(
    'add coaching request, '
    'coach to client, '
    'receiver already has a coach, '
    'should throw CoachingRequestException with userAlreadyHasCoach code',
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      const CustomException expectedException = CoachingRequestException(
        code: CoachingRequestExceptionCode.userAlreadyHasCoach,
      );
      firebaseUserService.mockLoadUserById(
        userDto: createUserDto(id: receiverId, coachId: 'c1'),
      );
      firebaseCoachingRequestService.mockAddCoachingRequest();

      Object? exception;
      try {
        await service.addCoachingRequest(
          senderId: senderId,
          receiverId: receiverId,
          direction: CoachingRequestDirection.coachToClient,
          isAccepted: false,
        );
      } catch (e) {
        exception = e;
      }

      expect(exception, expectedException);
      verify(
        () => firebaseUserService.loadUserById(userId: receiverId),
      ).called(1);
    },
  );

  test(
    'add coaching request, '
    'client to coach, '
    "should call firebase coaching request service's method to add coaching request",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      const bool isAccepted = false;
      firebaseCoachingRequestService.mockAddCoachingRequest();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        direction: CoachingRequestDirection.clientToCoach,
        isAccepted: isAccepted,
      );

      verify(
        () => firebaseCoachingRequestService.addCoachingRequest(
          senderId: senderId,
          receiverId: receiverId,
          direction: firebase.CoachingRequestDirection.clientToCoach,
          isAccepted: isAccepted,
        ),
      ).called(1);
    },
  );

  test(
    'update coaching request, '
    "should call firebase coaching request service's method to update coaching request",
    () async {
      const String requestId = 'i1';
      const bool isAccepted = true;
      firebaseCoachingRequestService.mockUpdateCoachingRequest();

      await service.updateCoachingRequest(
        requestId: requestId,
        isAccepted: isAccepted,
      );

      verify(
        () => firebaseCoachingRequestService.updateCoachingRequest(
          requestId: requestId,
          isAccepted: isAccepted,
        ),
      ).called(1);
    },
  );

  test(
    'delete coaching request, '
    "should call firebase coaching request service's method to delete coaching request",
    () async {
      const String requestId = 'i1';
      firebaseCoachingRequestService.mockDeleteCoachingRequest();

      await service.deleteCoachingRequest(requestId: requestId);

      verify(
        () => firebaseCoachingRequestService.deleteCoachingRequest(
          requestId: requestId,
        ),
      ).called(1);
    },
  );

  test(
    'delete accepted coaching requests by sender id, '
    "should call firebase coaching request service's method to delete accepted coaching requests by sender id",
    () async {
      const String senderId = 'u1';
      firebaseCoachingRequestService
          .mockDeleteAcceptedCoachingRequestsBySenderId();

      await service.deleteAcceptedCoachingRequestsBySenderId(
        senderId: senderId,
      );

      verify(
        () => firebaseCoachingRequestService
            .deleteAcceptedCoachingRequestsBySenderId(
          senderId: senderId,
        ),
      ).called(1);
    },
  );

  test(
    'delete unaccepted coaching requests by receiver id, '
    "should call firebase coaching request service's method to delete unaccepted coaching requests by receiver id",
    () async {
      const String receiverId = 'u1';
      firebaseCoachingRequestService
          .mockDeleteUnacceptedCoachingRequestsByReceiverId();

      await service.deleteUnacceptedCoachingRequestsByReceiverId(
        receiverId: receiverId,
      );

      verify(
        () => firebaseCoachingRequestService
            .deleteUnacceptedCoachingRequestsByReceiverId(
          receiverId: receiverId,
        ),
      ).called(1);
    },
  );
}
