import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/implementation/service/coaching_request_service_impl.dart';
import 'package:runnoter/data/interface/service/coaching_request_service.dart';
import 'package:runnoter/data/model/custom_exception.dart';

import '../../creators/user_dto_creator.dart';
import '../../mock/firebase/mock_firebase_coaching_request_service.dart';
import '../../mock/firebase/mock_firebase_user_service.dart';

void main() {
  final dbCoachingRequestService = MockFirebaseCoachingRequestService();
  final dbUserService = MockFirebaseUserService();
  late CoachingRequestServiceImpl service;

  setUpAll(() {
    GetIt.I.registerFactory<firebase.FirebaseCoachingRequestService>(
      () => dbCoachingRequestService,
    );
    GetIt.I.registerFactory<firebase.FirebaseUserService>(
      () => dbUserService,
    );
    service = CoachingRequestServiceImpl();
  });

  tearDown(() {
    reset(dbCoachingRequestService);
    reset(dbUserService);
  });

  test(
    'get coaching requests by sender id, '
    'should emit stream from db coaching request service to get coaching requests by sender id',
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
      dbCoachingRequestService.mockGetCoachingRequestsBySenderId(
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
        () => dbCoachingRequestService.getCoachingRequestsBySenderId(
          senderId: senderId,
          direction: firebase.CoachingRequestDirection.clientToCoach,
        ),
      ).called(1);
    },
  );

  test(
    'get coaching requests by receiver id, '
    'should emit stream from db coaching request service to get coaching requests by receiver id',
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
      dbCoachingRequestService.mockGetCoachingRequestsByReceiverId(
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
        () => dbCoachingRequestService.getCoachingRequestsByReceiverId(
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
    "should call db coaching request service's method to add coaching request",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      const bool isAccepted = false;
      dbUserService.mockLoadUserById(
        userDto: createUserDto(id: receiverId),
      );
      dbCoachingRequestService.mockAddCoachingRequest();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        direction: CoachingRequestDirection.coachToClient,
        isAccepted: isAccepted,
      );

      verify(
        () => dbUserService.loadUserById(userId: receiverId),
      ).called(1);
      verify(
        () => dbCoachingRequestService.addCoachingRequest(
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
      dbUserService.mockLoadUserById(
        userDto: createUserDto(id: receiverId, coachId: 'c1'),
      );
      dbCoachingRequestService.mockAddCoachingRequest();

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
        () => dbUserService.loadUserById(userId: receiverId),
      ).called(1);
    },
  );

  test(
    'add coaching request, '
    'client to coach, '
    "should call db coaching request service's method to add coaching request",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      const bool isAccepted = false;
      dbCoachingRequestService.mockAddCoachingRequest();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        direction: CoachingRequestDirection.clientToCoach,
        isAccepted: isAccepted,
      );

      verify(
        () => dbCoachingRequestService.addCoachingRequest(
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
    "should call db coaching request service's method to update coaching request",
    () async {
      const String requestId = 'i1';
      const bool isAccepted = true;
      dbCoachingRequestService.mockUpdateCoachingRequest();

      await service.updateCoachingRequest(
        requestId: requestId,
        isAccepted: isAccepted,
      );

      verify(
        () => dbCoachingRequestService.updateCoachingRequest(
          requestId: requestId,
          isAccepted: isAccepted,
        ),
      ).called(1);
    },
  );

  test(
    'delete coaching request, '
    "should call db coaching request service's method to delete coaching request",
    () async {
      const String requestId = 'i1';
      dbCoachingRequestService.mockDeleteCoachingRequest();

      await service.deleteCoachingRequest(requestId: requestId);

      verify(
        () => dbCoachingRequestService.deleteCoachingRequest(
          requestId: requestId,
        ),
      ).called(1);
    },
  );

  test(
    'delete coaching requests by user id, '
    'should call db coaching request service method to delete coaching requests by user id',
    () async {
      const String userId = 'u1';
      dbCoachingRequestService.mockDeleteCoachingRequestsByUserId();

      await service.deleteCoachingRequestsByUserId(userId: userId);

      verify(
        () => dbCoachingRequestService.deleteCoachingRequestsByUserId(
          userId: userId,
        ),
      ).called(1);
    },
  );

  test(
    'delete coaching request between users, '
    'should call db coaching request service method to delete coaching request '
    'between users',
    () async {
      const String user1Id = 'u1';
      const String user2Id = 'u2';
      dbCoachingRequestService.mockDeleteCoachingRequestBetweenUsers();

      await service.deleteCoachingRequestBetweenUsers(
        user1Id: user1Id,
        user2Id: user2Id,
      );

      verify(
        () => dbCoachingRequestService.deleteCoachingRequestBetweenUsers(
          user1Id: user1Id,
          user2Id: user2Id,
        ),
      ).called(1);
    },
  );
}
