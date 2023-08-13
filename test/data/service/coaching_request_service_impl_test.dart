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
          isAccepted: false,
        ),
        firebase.CoachingRequestDto(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          isAccepted: true,
        ),
      ];
      const List<CoachingRequest> expectedCoachingRequests = [
        CoachingRequest(
          id: 'i1',
          senderId: senderId,
          receiverId: 'u2',
          isAccepted: false,
        ),
        CoachingRequest(
          id: 'i2',
          senderId: senderId,
          receiverId: 'u3',
          isAccepted: true,
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
          isAccepted: false,
        ),
        firebase.CoachingRequestDto(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          isAccepted: true,
        ),
      ];
      const List<CoachingRequest> expectedCoachingRequests = [
        CoachingRequest(
          id: 'i1',
          senderId: 'u2',
          receiverId: receiverId,
          isAccepted: false,
        ),
        CoachingRequest(
          id: 'i2',
          senderId: 'u3',
          receiverId: receiverId,
          isAccepted: true,
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
      const bool isAccepted = false;
      firebaseUserService.mockLoadUserById(
        userDto: createUserDto(id: receiverId),
      );
      firebaseCoachingRequestService.mockAddCoachingRequest();

      await service.addCoachingRequest(
        senderId: senderId,
        receiverId: receiverId,
        isAccepted: isAccepted,
      );

      verify(
        () => firebaseUserService.loadUserById(userId: receiverId),
      ).called(1);
      verify(
        () => firebaseCoachingRequestService.addCoachingRequest(
          senderId: senderId,
          receiverId: receiverId,
          isAccepted: isAccepted,
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
    'delete unaccepted coaching requests by receiver id, '
    "should call firebase coaching request service's method to delete coaching requests by receiver id",
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
