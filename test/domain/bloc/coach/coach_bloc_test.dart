import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/user_basic_info.dart';
import 'package:runnoter/domain/bloc/coach/coach_bloc.dart';
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
  final userRepository = MockUserRepository();
  final coachingRequestService = MockCoachingRequestService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerLazySingleton<UserRepository>(() => userRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(coachingRequestService);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => CoachBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'logged user has coach, '
    'should load coach and update coach param in state',
    build: () => CoachBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      when(
        () => userRepository.getUserById(userId: loggedUserId),
      ).thenAnswer((_) => Stream.value(createUser(coachId: 'c1')));
      when(
        () => userRepository.getUserById(userId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(
          createUser(
            id: 'c1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [
      const CoachState(
        status: BlocStatusComplete(),
        coach: UserBasicInfo(
          id: 'c1',
          gender: Gender.male,
          name: 'name1',
          surname: 'surname1',
          email: 'email1@example.com',
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
      verify(() => userRepository.getUserById(userId: 'c1')).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged does not have a coach, '
    'should load and emit all received coaching requests',
    build: () => CoachBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      when(
        () => userRepository.getUserById(userId: loggedUserId),
      ).thenAnswer((_) => Stream.value(createUser(id: loggedUserId)));
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: [
          createCoachingRequest(id: 'i1'),
          createCoachingRequest(id: 'i2'),
        ],
      );
    },
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [
      CoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          createCoachingRequest(id: 'i1'),
          createCoachingRequest(id: 'i2'),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(() => userRepository.getUserById(userId: loggedUserId)).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: loggedUserId,
        ),
      ).called(1);
    },
  );
}
