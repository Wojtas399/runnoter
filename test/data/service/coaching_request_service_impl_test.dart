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
          status: firebase.CoachingRequestStatus.pending,
        ),
        firebase.CoachingRequestDto(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          status: firebase.CoachingRequestStatus.accepted,
        ),
        firebase.CoachingRequestDto(
          id: 'i3',
          senderId: senderId,
          receiverId: 'u4',
          status: firebase.CoachingRequestStatus.declined,
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
      firebaseCoachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: requestDtos,
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
    'should emit stream from firebase coaching request service to get coaching requests by receiver id',
    () {
      const String receiverId = 'u1';
      const List<firebase.CoachingRequestDto> requestDtos = [
        firebase.CoachingRequestDto(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          status: firebase.CoachingRequestStatus.pending,
        ),
        firebase.CoachingRequestDto(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          status: firebase.CoachingRequestStatus.accepted,
        ),
        firebase.CoachingRequestDto(
          id: 'i3',
          senderId: 'u4',
          receiverId: receiverId,
          status: firebase.CoachingRequestStatus.declined,
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
      firebaseCoachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: requestDtos,
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
    "should call firebase coaching request service's method to add coaching request",
    () async {
      const String senderId = 'u1';
      const String receiverId = 'u2';
      firebaseUserService.mockLoadUserById(
        userDto: createUserDto(id: receiverId),
      );
      firebaseCoachingRequestService.mockAddCoachingRequest();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        status: CoachingRequestStatus.pending,
      );

      verify(
        () => firebaseUserService.loadUserById(userId: receiverId),
      ).called(1);
      verify(
        () => firebaseCoachingRequestService.addCoachingRequest(
          senderId: senderId,
          receiverId: receiverId,
          status: firebase.CoachingRequestStatus.pending,
        ),
      ).called(1);
    },
  );

  test(
    'add coaching request, '
    'receiver already has coach, '
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
          status: CoachingRequestStatus.pending,
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
    'update coaching request status, '
    "should call firebase coaching request service's method to update coaching request's status",
    () async {
      const String requestId = 'i1';
      firebaseCoachingRequestService.mockUpdateCoachingRequestStatus();

      await service.updateCoachingRequestStatus(
        requestId: requestId,
        status: CoachingRequestStatus.declined,
      );

      verify(
        () => firebaseCoachingRequestService.updateCoachingRequestStatus(
          requestId: requestId,
          status: firebase.CoachingRequestStatus.declined,
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
}
