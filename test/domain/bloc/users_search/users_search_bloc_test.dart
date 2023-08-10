import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/users_search/users_search_bloc.dart';
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
    GetIt.I.registerSingleton<UserBasicInfoRepository>(userBasicInfoRepository);
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
    build: () => UsersSearchBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const UsersSearchEventInitialize()),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'found users does not exist, '
    'should only emit client ids and invited users ids',
    build: () => UsersSearchBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userBasicInfoRepository.mockGetUsersBasicInfoByCoachId(
        usersBasicInfo: [
          createUserBasicInfo(id: 'u2'),
          createUserBasicInfo(id: 'u3'),
        ],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(
            receiverId: 'u4',
            status: CoachingRequestStatus.pending,
          ),
          createCoachingRequest(
            receiverId: 'u5',
            status: CoachingRequestStatus.accepted,
          ),
          createCoachingRequest(
            receiverId: 'u3',
            status: CoachingRequestStatus.accepted,
          ),
          createCoachingRequest(
            receiverId: 'u6',
            status: CoachingRequestStatus.declined,
          ),
        ],
      );
    },
    act: (bloc) => bloc.add(const UsersSearchEventInitialize()),
    expect: () => [
      const UsersSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u2', 'u3', 'u5'],
        invitedUserIds: ['u4'],
      ),
    ],
  );

  blocTest(
    'initialize, '
    'found users exists, '
    'should emit client ids, ids of invited users and found users',
    build: () => UsersSearchBloc(
      state: UsersSearchState(
        status: const BlocStatusComplete(),
        foundUsers: [
          FoundUser(
            info: createUserBasicInfo(id: 'u2'),
            relationshipStatus: RelationshipStatus.pending,
          ),
          FoundUser(
            info: createUserBasicInfo(id: 'u4'),
            relationshipStatus: RelationshipStatus.notInvited,
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userBasicInfoRepository.mockGetUsersBasicInfoByCoachId(
        usersBasicInfo: [
          createUserBasicInfo(id: 'u2'),
          createUserBasicInfo(id: 'u3'),
        ],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(
            receiverId: 'u4',
            status: CoachingRequestStatus.pending,
          ),
          createCoachingRequest(
            receiverId: 'u5',
            status: CoachingRequestStatus.accepted,
          ),
          createCoachingRequest(
            receiverId: 'u3',
            status: CoachingRequestStatus.accepted,
          ),
          createCoachingRequest(
            receiverId: 'u6',
            status: CoachingRequestStatus.declined,
          ),
        ],
      );
    },
    act: (bloc) => bloc.add(const UsersSearchEventInitialize()),
    expect: () => [
      UsersSearchState(
        status: const BlocStatusComplete(),
        clientIds: const ['u2', 'u3', 'u5'],
        invitedUserIds: const ['u4'],
        foundUsers: [
          FoundUser(
            info: createUserBasicInfo(id: 'u2'),
            relationshipStatus: RelationshipStatus.accepted,
          ),
          FoundUser(
            info: createUserBasicInfo(id: 'u4'),
            relationshipStatus: RelationshipStatus.pending,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'search, '
    'search query is empty string, '
    'should set found users as null',
    build: () => UsersSearchBloc(
      state: const UsersSearchState(
        status: BlocStatusComplete(),
        searchQuery: 'sea',
        foundUsers: [],
      ),
    ),
    act: (bloc) => bloc.add(const UsersSearchEventSearch(
      searchQuery: '',
    )),
    expect: () => [
      const UsersSearchState(
        status: BlocStatusComplete(),
        searchQuery: '',
        foundUsers: null,
      ),
    ],
  );

  blocTest(
    'search, '
    "should call user repository's method to search users and should updated found users in state",
    build: () => UsersSearchBloc(
      state: const UsersSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u12'],
        invitedUserIds: ['u2'],
      ),
    ),
    setUp: () => userBasicInfoRepository.mockSearchForUsers(
      usersBasicInfo: [
        createUserBasicInfo(
          id: 'u12',
          name: 'na1',
          surname: 'su1',
          coachId: loggedUserId,
        ),
        createUserBasicInfo(id: 'u2', name: 'na2', surname: 'su2'),
        createUserBasicInfo(id: 'u3', name: 'na3', surname: 'su3'),
        createUserBasicInfo(
          id: 'u4',
          name: 'na4',
          surname: 'su4',
          coachId: 'c1',
        ),
      ],
    ),
    act: (bloc) => bloc.add(const UsersSearchEventSearch(searchQuery: 'sea')),
    expect: () => [
      const UsersSearchState(
        status: BlocStatusLoading(),
        clientIds: ['u12'],
        invitedUserIds: ['u2'],
      ),
      UsersSearchState(
        status: const BlocStatusComplete(),
        searchQuery: 'sea',
        clientIds: const ['u12'],
        invitedUserIds: const ['u2'],
        foundUsers: [
          FoundUser(
            info: createUserBasicInfo(
              id: 'u12',
              name: 'na1',
              surname: 'su1',
              coachId: loggedUserId,
            ),
            relationshipStatus: RelationshipStatus.accepted,
          ),
          FoundUser(
            info: createUserBasicInfo(id: 'u2', name: 'na2', surname: 'su2'),
            relationshipStatus: RelationshipStatus.pending,
          ),
          FoundUser(
            info: createUserBasicInfo(id: 'u3', name: 'na3', surname: 'su3'),
            relationshipStatus: RelationshipStatus.notInvited,
          ),
          FoundUser(
            info: createUserBasicInfo(
              id: 'u4',
              name: 'na4',
              surname: 'su4',
              coachId: 'c1',
            ),
            relationshipStatus: RelationshipStatus.alreadyTaken,
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => userBasicInfoRepository.searchForUsers(searchQuery: 'sea'),
    ).called(1),
  );

  blocTest(
    'invite user, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => UsersSearchBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const UsersSearchEventInviteUser(
      idOfUserToInvite: 'u2',
    )),
    expect: () => [
      const UsersSearchState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'invite user, '
    "should call invite repository's method to add invite with given user id set as receiver id and pending invitation status",
    build: () => UsersSearchBloc(
      state: const UsersSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest();
    },
    act: (bloc) => bloc.add(const UsersSearchEventInviteUser(
      idOfUserToInvite: 'u2',
    )),
    expect: () => [
      const UsersSearchState(status: BlocStatusLoading()),
      const UsersSearchState(
        status: BlocStatusComplete<UsersSearchBlocInfo>(
          info: UsersSearchBlocInfo.requestSent,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.addCoachingRequest(
          senderId: 'u1',
          receiverId: 'u2',
          status: CoachingRequestStatus.pending,
        ),
      ).called(1);
    },
  );

  blocTest(
    'invite user, '
    'CoachingRequestException with userAlreadyHasCoach code, '
    'should emit error status with userAlreadyHasCoach error',
    build: () => UsersSearchBloc(
      state: const UsersSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest(
        throwable: const CoachingRequestException(
          code: CoachingRequestExceptionCode.userAlreadyHasCoach,
        ),
      );
    },
    act: (bloc) => bloc.add(const UsersSearchEventInviteUser(
      idOfUserToInvite: 'u2',
    )),
    expect: () => [
      const UsersSearchState(status: BlocStatusLoading()),
      const UsersSearchState(
        status: BlocStatusError<UsersSearchBlocError>(
          error: UsersSearchBlocError.userAlreadyHasCoach,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.addCoachingRequest(
          senderId: 'u1',
          receiverId: 'u2',
          status: CoachingRequestStatus.pending,
        ),
      ).called(1);
    },
  );
}
