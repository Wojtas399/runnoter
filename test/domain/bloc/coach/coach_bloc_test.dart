import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/bloc/coach/coach_bloc.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/entity/user_basic_info.dart';
import 'package:runnoter/domain/repository/user_basic_info_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/user_basic_info_creator.dart';
import '../../../mock/domain/repository/mock_user_basic_info_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userBasicInfoRepository = MockUserBasicInfoRepository();
  final coachingRequestService = MockCoachingRequestService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerFactory<UserBasicInfoRepository>(
      () => userBasicInfoRepository,
    );
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(userBasicInfoRepository);
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
        () => userBasicInfoRepository.getUserBasicInfoByUserId(
          userId: loggedUserId,
        ),
      ).thenAnswer((_) => Stream.value(createUserBasicInfo(coachId: 'c1')));
      when(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(userId: 'c1'),
      ).thenAnswer(
        (_) => Stream.value(
          createUserBasicInfo(
            id: 'c1',
            gender: Gender.male,
            name: 'name1',
            surname: 'surname1',
            email: 'email1@example.com',
          ),
        ),
      );
      coachingRequestService.mockGetCoachingRequestsByReceiverId();
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
      verify(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(userId: 'c1'),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'logged user does not have a coach, '
    'should load and emit all received coaching requests',
    build: () => CoachBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      when(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(
          userId: loggedUserId,
        ),
      ).thenAnswer(
        (_) => Stream.value(createUserBasicInfo(id: loggedUserId)),
      );
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: [
          createCoachingRequest(id: 'i1', senderId: 'u2'),
          createCoachingRequest(id: 'i2', senderId: 'u3'),
        ],
      );
      when(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(userId: 'u2'),
      ).thenAnswer(
        (_) => Stream.value(createUserBasicInfo(id: 'u2', name: 'name2')),
      );
      when(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(userId: 'u3'),
      ).thenAnswer(
        (_) => Stream.value(createUserBasicInfo(id: 'u3', name: 'name3')),
      );
    },
    act: (bloc) => bloc.add(const CoachEventInitialize()),
    expect: () => [
      CoachState(
        status: const BlocStatusComplete(),
        receivedCoachingRequests: [
          CoachingRequestInfo(
            id: 'i1',
            senderInfo: createUserBasicInfo(id: 'u2', name: 'name2'),
          ),
          CoachingRequestInfo(
            id: 'i2',
            senderInfo: createUserBasicInfo(id: 'u3', name: 'name3'),
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(
          userId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsByReceiverId(
          receiverId: loggedUserId,
        ),
      ).called(1);
      verify(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(userId: 'u2'),
      ).called(1);
      verify(
        () => userBasicInfoRepository.getUserBasicInfoByUserId(userId: 'u3'),
      ).called(1);
    },
  );
}
