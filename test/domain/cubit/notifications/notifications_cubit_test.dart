import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/cubit/notifications/notifications_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/repository/user_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final coachingRequestService = MockCoachingRequestService();
  final userRepository = MockUserRepository();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
    GetIt.I.registerSingleton<UserRepository>(userRepository);
  });

  tearDown(() {
    reset(authService);
    reset(coachingRequestService);
    reset(userRepository);
  });

  blocTest(
    'initialize, '
    'logged user is not a coach, '
    'should do nothing',
    build: () => NotificationsCubit(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(
        user: createUser(
          id: loggedUserId,
          accountType: AccountType.runner,
        ),
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [],
  );

  group(
    'initialize, '
    'logged user is a coach',
    () {
      const String loggedUserId = 'u1';
      final List<CoachingRequest> requestsReceivedFromClients = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: true),
      ];
      final List<CoachingRequest> updatedRequestsReceivedFromClients = [
        createCoachingRequest(id: 'r1', isAccepted: false),
        createCoachingRequest(id: 'r2', isAccepted: true),
        createCoachingRequest(id: 'r3', isAccepted: true),
        createCoachingRequest(id: 'r4', isAccepted: false),
        createCoachingRequest(id: 'r5', isAccepted: false),
      ];
      StreamController<List<CoachingRequest>> requestsReceivedFromClients$ =
          StreamController()..add(requestsReceivedFromClients);

      blocTest(
        'should listen to number of unaccepted requests received from clients',
        build: () => NotificationsCubit(),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(
            user: createUser(id: loggedUserId, accountType: AccountType.coach),
          );
          coachingRequestService.mockGetCoachingRequestsByReceiverId(
            requestsStream: requestsReceivedFromClients$.stream,
          );
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          requestsReceivedFromClients$.add(updatedRequestsReceivedFromClients);
        },
        expect: () => [
          const NotificationsState(
            numberOfCoachingRequestsReceivedFromClients: 1,
          ),
          const NotificationsState(
            numberOfCoachingRequestsReceivedFromClients: 3,
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
        },
      );
    },
  );
}
