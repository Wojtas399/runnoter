import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/additional_model/bloc_status.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/cubit/persons_search/persons_search_cubit.dart';
import 'package:runnoter/domain/entity/user.dart';
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
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'initialize, '
    'coach to client direction, '
    'found persons do not exist, '
    'should only emit client ids and invited persons ids',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(receiverId: 'u4', isAccepted: false),
          createCoachingRequest(receiverId: 'u5', isAccepted: true),
          createCoachingRequest(receiverId: 'u3', isAccepted: true),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const PersonsSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u2', 'u3', 'u5'],
        invitedPersonIds: ['u4'],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
          direction: CoachingRequestDirection.coachToClient,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'coach to client direction, '
    'found persons exist, '
    'should emit client ids, ids of invited persons and updated found persons',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: PersonsSearchState(
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
          createCoachingRequest(receiverId: 'u4', isAccepted: false),
          createCoachingRequest(receiverId: 'u5', isAccepted: true),
          createCoachingRequest(receiverId: 'u3', isAccepted: true),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
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
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
          direction: CoachingRequestDirection.coachToClient,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'coach to client direction, '
    'found persons do not exist, '
    'should only emit client ids and invited persons ids',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.clientToCoach,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u2'), createPerson(id: 'u3')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [
          createCoachingRequest(receiverId: 'u4', isAccepted: false),
          createCoachingRequest(receiverId: 'u5', isAccepted: true),
          createCoachingRequest(receiverId: 'u3', isAccepted: true),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const PersonsSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u2', 'u3', 'u5'],
        invitedPersonIds: ['u4'],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
          direction: CoachingRequestDirection.clientToCoach,
        ),
      ).called(1);
    },
  );

  blocTest(
    'initialize, '
    'client to coach direction, '
    'found persons exist, '
    'should emit client ids, ids of invited persons and updated found persons',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.clientToCoach,
      initialState: PersonsSearchState(
        status: const BlocStatusComplete(),
        foundPersons: [
          FoundPerson(
            info: createPerson(id: 'u2'),
            relationshipStatus: RelationshipStatus.pending,
          ),
          FoundPerson(
            info: createPerson(id: 'u4', coachId: 'c1'),
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
          createCoachingRequest(receiverId: 'u4', isAccepted: false),
          createCoachingRequest(receiverId: 'u5', isAccepted: true),
          createCoachingRequest(receiverId: 'u3', isAccepted: true),
        ],
      );
    },
    act: (cubit) => cubit.initialize(),
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
            info: createPerson(id: 'u4', coachId: 'c1'),
            relationshipStatus: RelationshipStatus.pending,
          ),
        ],
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
      ).called(1);
      verify(
        () => coachingRequestService.getCoachingRequestsBySenderId(
          senderId: loggedUserId,
          direction: CoachingRequestDirection.clientToCoach,
        ),
      ).called(1);
    },
  );

  blocTest(
    'search, '
    'search query is empty string, '
    'should set found persons as null',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: const PersonsSearchState(
        status: BlocStatusComplete(),
        searchQuery: 'sea',
        foundPersons: [],
      ),
    ),
    act: (cubit) => cubit.search(''),
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
    'coach to client request direction, '
    "should call person repository's method to search persons and should update found persons in state",
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: const PersonsSearchState(
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
    act: (cubit) => cubit.search('sea'),
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
    'search, '
    'client to coach request direction, '
    "should call person repository's method to search persons and should update found persons in state",
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.clientToCoach,
      initialState: const PersonsSearchState(
        status: BlocStatusComplete(),
        clientIds: ['u12'],
        invitedPersonIds: ['u2'],
      ),
    ),
    setUp: () => personRepository.mockSearchForPersons(
      persons: [
        createPerson(id: 'u12', name: 'na1', surname: 'su1'),
        createPerson(id: 'u2', name: 'na2', surname: 'su2', coachId: 'c1'),
        createPerson(id: 'u3', name: 'na3', surname: 'su3', coachId: 'c2'),
        createPerson(id: 'u4', name: 'na4', surname: 'su4', coachId: 'c1'),
      ],
    ),
    act: (cubit) => cubit.search('sea'),
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
            info: createPerson(id: 'u12', name: 'na1', surname: 'su1'),
            relationshipStatus: RelationshipStatus.accepted,
          ),
          FoundPerson(
            info: createPerson(
              id: 'u2',
              name: 'na2',
              surname: 'su2',
              coachId: 'c1',
            ),
            relationshipStatus: RelationshipStatus.pending,
          ),
          FoundPerson(
            info: createPerson(
              id: 'u3',
              name: 'na3',
              surname: 'su3',
              coachId: 'c2',
            ),
            relationshipStatus: RelationshipStatus.notInvited,
          ),
          FoundPerson(
            info: createPerson(
              id: 'u4',
              name: 'na4',
              surname: 'su4',
              coachId: 'c1',
            ),
            relationshipStatus: RelationshipStatus.notInvited,
          ),
        ],
      ),
    ],
    verify: (_) => verify(
      () => personRepository.searchForPersons(
        searchQuery: 'sea',
        accountType: AccountType.coach,
      ),
    ).called(1),
  );

  blocTest(
    'invite person, '
    'logged user does not exist, '
    'should emit no logged user status',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.invitePerson('u2'),
    expect: () => [
      const PersonsSearchState(status: BlocStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'invite person, '
    'coach to client, '
    "should call coaching request repository's method to add request with given person id set as receiver id, coachToClient direction and pending invitation status",
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: const PersonsSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest();
    },
    act: (cubit) => cubit.invitePerson('u2'),
    expect: () => [
      const PersonsSearchState(status: BlocStatusLoading()),
      const PersonsSearchState(
        status: BlocStatusComplete<PersonsSearchCubitInfo>(
          info: PersonsSearchCubitInfo.requestSent,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.addCoachingRequest(
          senderId: 'u1',
          receiverId: 'u2',
          direction: CoachingRequestDirection.coachToClient,
          isAccepted: false,
        ),
      ).called(1);
    },
  );

  blocTest(
    'invite person, '
    'client to coach, '
    "should call coaching request repository's method to add request with given person id set as receiver id, clientToCoach direction and pending invitation status",
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.clientToCoach,
      initialState: const PersonsSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest();
    },
    act: (cubit) => cubit.invitePerson('u2'),
    expect: () => [
      const PersonsSearchState(status: BlocStatusLoading()),
      const PersonsSearchState(
        status: BlocStatusComplete<PersonsSearchCubitInfo>(
          info: PersonsSearchCubitInfo.requestSent,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.addCoachingRequest(
          senderId: 'u1',
          receiverId: 'u2',
          direction: CoachingRequestDirection.clientToCoach,
          isAccepted: false,
        ),
      ).called(1);
    },
  );

  blocTest(
    'invite user, '
    'CoachingRequestException with userAlreadyHasCoach code, '
    'should emit error status with userAlreadyHasCoach error',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: const PersonsSearchState(status: BlocStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest(
        throwable: const CoachingRequestException(
          code: CoachingRequestExceptionCode.userAlreadyHasCoach,
        ),
      );
    },
    act: (cubit) => cubit.invitePerson('u2'),
    expect: () => [
      const PersonsSearchState(status: BlocStatusLoading()),
      const PersonsSearchState(
        status: BlocStatusError<PersonsSearchCubitError>(
          error: PersonsSearchCubitError.userAlreadyHasCoach,
        ),
      ),
    ],
    verify: (_) {
      verify(() => authService.loggedUserId$).called(1);
      verify(
        () => coachingRequestService.addCoachingRequest(
          senderId: 'u1',
          receiverId: 'u2',
          direction: CoachingRequestDirection.coachToClient,
          isAccepted: false,
        ),
      ).called(1);
    },
  );
}
