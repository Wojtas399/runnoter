import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/bloc/persons_search/persons_search_bloc.dart';
import 'package:runnoter/domain/repository/person_repository.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final personRepository = MockPersonRepository();
  final coachingRequestService = MockCoachingRequestService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(personRepository);
    reset(coachingRequestService);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should do nothing',
    build: () => PersonsSearchBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const PersonsSearchEventInitialize()),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'found persons do not exist, '
    'should only emit client ids and invited persons ids',
    build: () => PersonsSearchBloc(),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
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
    act: (bloc) => bloc.add(const PersonsSearchEventInitialize()),
    expect: () => [
      const PersonsSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u2', 'u3', 'u5'],
        invitedPersonIds: ['u4'],
      ),
    ],
  );

  blocTest(
    'initialize, '
    'found persons exist, '
    'should emit client ids, ids of invited persons and found persons',
    build: () => PersonsSearchBloc(
      state: PersonsSearchState(
        status: const BlocStatusComplete(),
        foundPersons: [
          FoundPerson(
            info: createPerson(id: 'u2'),
            relationshipStatus: RelationshipStatus.pending,
          ),
          FoundPerson(
            info: createPerson(id: 'u4'),
            relationshipStatus: RelationshipStatus.notInvited,
          ),
        ],
      ),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
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
    act: (bloc) => bloc.add(const PersonsSearchEventInitialize()),
    expect: () => [
      PersonsSearchState(
        status: const BlocStatusComplete(),
        clientIds: const ['u2', 'u3', 'u5'],
        invitedPersonIds: const ['u4'],
        foundPersons: [
          FoundPerson(
            info: createPerson(id: 'u2'),
            relationshipStatus: RelationshipStatus.accepted,
          ),
          FoundPerson(
            info: createPerson(id: 'u4'),
            relationshipStatus: RelationshipStatus.pending,
          ),
        ],
      ),
    ],
  );

  blocTest(
    'search, '
    'search query is empty string, '
    'should set found persons as null',
    build: () => PersonsSearchBloc(
      state: const PersonsSearchState(
        status: BlocStatusComplete(),
        searchQuery: 'sea',
        foundPersons: [],
      ),
    ),
    act: (bloc) => bloc.add(const PersonsSearchEventSearch(
      searchQuery: '',
    )),
    expect: () => [
      const PersonsSearchState(
        status: BlocStatusComplete(),
        searchQuery: '',
        foundPersons: null,
      ),
    ],
  );

  blocTest(
    'search, '
    "should call person repository's method to search persons and should update found persons in state",
    build: () => PersonsSearchBloc(
      state: const PersonsSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u12'],
        invitedPersonIds: ['u2'],
      ),
    ),
    setUp: () => personRepository.mockSearchForPersons(
      persons: [
        createPerson(
          id: 'u12',
          name: 'na1',
          surname: 'su1',
          coachId: loggedUserId,
        ),
        createPerson(id: 'u2', name: 'na2', surname: 'su2'),
        createPerson(id: 'u3', name: 'na3', surname: 'su3'),
        createPerson(
          id: 'u4',
          name: 'na4',
          surname: 'su4',
          coachId: 'c1',
        ),
      ],
    ),
    act: (bloc) => bloc.add(const PersonsSearchEventSearch(searchQuery: 'sea')),
    expect: () => [
      const PersonsSearchState(
        status: BlocStatusLoading(),
        clientIds: ['u12'],
        invitedPersonIds: ['u2'],
      ),
      PersonsSearchState(
        status: const BlocStatusComplete(),
        searchQuery: 'sea',
        clientIds: const ['u12'],
        invitedPersonIds: const ['u2'],
        foundPersons: [
          FoundPerson(
            info: createPerson(
              id: 'u12',
              name: 'na1',
              surname: 'su1',
              coachId: loggedUserId,
            ),
            relationshipStatus: RelationshipStatus.accepted,
          ),
          FoundPerson(
            info: createPerson(id: 'u2', name: 'na2', surname: 'su2'),
            relationshipStatus: RelationshipStatus.pending,
          ),
          FoundPerson(
            info: createPerson(id: 'u3', name: 'na3', surname: 'su3'),
            relationshipStatus: RelationshipStatus.notInvited,
          ),
          FoundPerson(
            info: createPerson(
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
      () => personRepository.searchForPersons(searchQuery: 'sea'),
    ).called(1),
  );

  blocTest(
    'invite person, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => PersonsSearchBloc(),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (bloc) => bloc.add(const PersonsSearchEventInvitePerson(
      personId: 'u2',
    )),
    expect: () => [
      const PersonsSearchState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'invite person, '
    "should call coaching request repository's method to add request with given person id set as receiver id and pending invitation status",
    build: () => PersonsSearchBloc(
      state: const PersonsSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest();
    },
    act: (bloc) => bloc.add(const PersonsSearchEventInvitePerson(
      personId: 'u2',
    )),
    expect: () => [
      const PersonsSearchState(status: BlocStatusLoading()),
      const PersonsSearchState(
        status: BlocStatusComplete<PersonsSearchBlocInfo>(
          info: PersonsSearchBlocInfo.requestSent,
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
    build: () => PersonsSearchBloc(
      state: const PersonsSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest(
        throwable: const CoachingRequestException(
          code: CoachingRequestExceptionCode.userAlreadyHasCoach,
        ),
      );
    },
    act: (bloc) => bloc.add(const PersonsSearchEventInvitePerson(
      personId: 'u2',
    )),
    expect: () => [
      const PersonsSearchState(status: BlocStatusLoading()),
      const PersonsSearchState(
        status: BlocStatusError<PersonsSearchBlocError>(
          error: PersonsSearchBlocError.userAlreadyHasCoach,
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
