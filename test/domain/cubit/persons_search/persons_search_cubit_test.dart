import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:runnoter/data/entity/person.dart';
import 'package:runnoter/data/entity/user.dart';
import 'package:runnoter/data/interface/repository/person_repository.dart';
import 'package:runnoter/data/interface/repository/user_repository.dart';
import 'package:runnoter/domain/additional_model/coaching_request.dart';
import 'package:runnoter/domain/additional_model/cubit_status.dart';
import 'package:runnoter/domain/additional_model/custom_exception.dart';
import 'package:runnoter/domain/cubit/persons_search/persons_search_cubit.dart';
import 'package:runnoter/domain/service/auth_service.dart';
import 'package:runnoter/domain/service/coaching_request_service.dart';

import '../../../creators/coaching_request_creator.dart';
import '../../../creators/person_creator.dart';
import '../../../creators/user_creator.dart';
import '../../../mock/domain/repository/mock_person_repository.dart';
import '../../../mock/domain/repository/mock_user_repository.dart';
import '../../../mock/domain/service/mock_auth_service.dart';
import '../../../mock/domain/service/mock_coaching_request_service.dart';

void main() {
  final authService = MockAuthService();
  final userRepository = MockUserRepository();
  final personRepository = MockPersonRepository();
  final coachingRequestService = MockCoachingRequestService();
  const String loggedUserId = 'u1';

  setUpAll(() {
    GetIt.I.registerFactory<AuthService>(() => authService);
    GetIt.I.registerSingleton<UserRepository>(userRepository);
    GetIt.I.registerSingleton<PersonRepository>(personRepository);
    GetIt.I.registerFactory<CoachingRequestService>(
      () => coachingRequestService,
    );
  });

  tearDown(() {
    reset(authService);
    reset(userRepository);
    reset(personRepository);
    reset(coachingRequestService);
  });

  blocTest(
    'initialize, '
    'logged user does not exist, '
    'should not listen to anything',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
    ),
    setUp: () => authService.mockGetLoggedUserId(),
    act: (cubit) => cubit.initialize(),
    expect: () => [
      const PersonsSearchState(status: CubitStatusComplete()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  group(
    'initialize, '
    'coach to client direction, ',
    () {
      final User loggedUser = createUser(id: loggedUserId);
      final User updatedLoggedUser = createUser(
        id: loggedUserId,
        coachId: 'p10',
      );
      final List<Person> clients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2')
      ];
      final List<Person> updatedClients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
        createPerson(id: 'p3'),
      ];
      final List<CoachingRequest> sentRequests = [
        createCoachingRequest(id: 'cr1', receiverId: 'p4', isAccepted: false),
        createCoachingRequest(id: 'cr2', receiverId: 'p5', isAccepted: true),
      ];
      final List<CoachingRequest> updatedSentRequests = [
        createCoachingRequest(id: 'cr1', receiverId: 'p4', isAccepted: false),
        createCoachingRequest(id: 'cr2', receiverId: 'p5', isAccepted: true),
        createCoachingRequest(id: 'cr3', receiverId: 'p6', isAccepted: false),
      ];
      final List<CoachingRequest> receivedRequests = [
        createCoachingRequest(id: 'cr4', senderId: 'p7', isAccepted: false),
      ];
      final List<CoachingRequest> updatedReceivedRequests = [
        createCoachingRequest(id: 'cr4', senderId: 'p7', isAccepted: false),
        createCoachingRequest(id: 'cr5', senderId: 'p8', isAccepted: false),
        createCoachingRequest(id: 'cr6', senderId: 'p9', isAccepted: true),
      ];
      final StreamController<User> loggedUser$ = StreamController()
        ..add(loggedUser);
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should listen to logged user data, client ids, invitee ids and inviter ids',
        build: () => PersonsSearchCubit(
          requestDirection: CoachingRequestDirection.coachToClient,
          initialState: PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
            ],
          ),
        ),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUser$.stream);
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
          coachingRequestService.mockGetCoachingRequestsBySenderId(
            requestsStream: sentRequests$.stream,
          );
          coachingRequestService.mockGetCoachingRequestsByReceiverId(
            requestsStream: receivedRequests$.stream,
          );
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          clients$.add(updatedClients);
          sentRequests$.add(updatedSentRequests);
          receivedRequests$.add(updatedReceivedRequests);
          await cubit.stream.first;
          loggedUser$.add(updatedLoggedUser);
        },
        expect: () => [
          PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.alreadyTaken,
              ),
            ],
          ),
          PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.alreadyTaken,
              ),
            ],
          ),
          PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
            ],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
        },
      );
    },
  );

  group(
    'initialize, '
    'client to coach direction, ',
    () {
      final User loggedUser = createUser(id: loggedUserId);
      final User updatedLoggedUser = createUser(
        id: loggedUserId,
        coachId: 'p10',
      );
      final List<Person> clients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2')
      ];
      final List<Person> updatedClients = [
        createPerson(id: 'p1'),
        createPerson(id: 'p2'),
        createPerson(id: 'p3'),
      ];
      final List<CoachingRequest> sentRequests = [
        createCoachingRequest(id: 'cr1', receiverId: 'p4', isAccepted: false),
        createCoachingRequest(id: 'cr2', receiverId: 'p5', isAccepted: true),
      ];
      final List<CoachingRequest> updatedSentRequests = [
        createCoachingRequest(id: 'cr1', receiverId: 'p4', isAccepted: false),
        createCoachingRequest(id: 'cr2', receiverId: 'p5', isAccepted: true),
        createCoachingRequest(id: 'cr3', receiverId: 'p6', isAccepted: false),
      ];
      final List<CoachingRequest> receivedRequests = [
        createCoachingRequest(id: 'cr4', senderId: 'p7', isAccepted: false),
      ];
      final List<CoachingRequest> updatedReceivedRequests = [
        createCoachingRequest(id: 'cr4', senderId: 'p7', isAccepted: false),
        createCoachingRequest(id: 'cr5', senderId: 'p8', isAccepted: false),
        createCoachingRequest(id: 'cr6', senderId: 'p9', isAccepted: true),
      ];
      final StreamController<User> loggedUser$ = StreamController()
        ..add(loggedUser);
      final StreamController<List<Person>> clients$ = StreamController()
        ..add(clients);
      final StreamController<List<CoachingRequest>> sentRequests$ =
          StreamController()..add(sentRequests);
      final StreamController<List<CoachingRequest>> receivedRequests$ =
          StreamController()..add(receivedRequests);

      blocTest(
        'should listen to logged user data, client ids, invitee ids and inviter ids',
        build: () => PersonsSearchCubit(
          requestDirection: CoachingRequestDirection.clientToCoach,
          initialState: PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
            ],
          ),
        ),
        setUp: () {
          authService.mockGetLoggedUserId(userId: loggedUserId);
          userRepository.mockGetUserById(userStream: loggedUser$.stream);
          personRepository.mockGetPersonsByCoachId(
            personsStream: clients$.stream,
          );
          coachingRequestService.mockGetCoachingRequestsBySenderId(
            requestsStream: sentRequests$.stream,
          );
          coachingRequestService.mockGetCoachingRequestsByReceiverId(
            requestsStream: receivedRequests$.stream,
          );
        },
        act: (cubit) async {
          cubit.initialize();
          await cubit.stream.first;
          clients$.add(updatedClients);
          sentRequests$.add(updatedSentRequests);
          receivedRequests$.add(updatedReceivedRequests);
          await cubit.stream.first;
          loggedUser$.add(updatedLoggedUser);
        },
        expect: () => [
          PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
            ],
          ),
          PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.notInvited,
              ),
            ],
          ),
          PersonsSearchState(
            status: const CubitStatusComplete(),
            foundPersons: [
              FoundPerson(
                info: createPerson(id: 'p1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p4'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p8'),
                relationshipStatus: RelationshipStatus.pending,
              ),
              FoundPerson(
                info: createPerson(id: 'p9'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
              FoundPerson(
                info: createPerson(id: 'p10', coachId: 'c1'),
                relationshipStatus: RelationshipStatus.accepted,
              ),
            ],
          ),
        ],
        verify: (_) {
          verify(() => authService.loggedUserId$).called(1);
          verify(
            () => userRepository.getUserById(userId: loggedUserId),
          ).called(1);
          verify(
            () => personRepository.getPersonsByCoachId(coachId: loggedUserId),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUserId,
              direction: CoachingRequestDirection.coachToClient,
            ),
          ).called(1);
          verify(
            () => coachingRequestService.getCoachingRequestsBySenderId(
              senderId: loggedUserId,
              direction: CoachingRequestDirection.clientToCoach,
            ),
          ).called(1);
        },
      );
    },
  );

  blocTest(
    'search, '
    'search query is empty string, '
    'should set found persons as null',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: const PersonsSearchState(
        status: CubitStatusComplete(),
        searchQuery: 'sea',
        foundPersons: [],
      ),
    ),
    act: (cubit) => cubit.search(''),
    expect: () => [
      const PersonsSearchState(
        status: CubitStatusComplete(),
        searchQuery: '',
        foundPersons: null,
      ),
    ],
  );

  blocTest(
    'search, '
    'coach to client direction, '
    'should call person repository method to search persons and '
    'should update found persons in state',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(user: createUser(coachId: 'u5'));
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u12')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [createCoachingRequest(receiverId: 'u2', isAccepted: false)],
      );
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: [createCoachingRequest(senderId: 'u3', isAccepted: false)],
      );
      personRepository.mockSearchForPersons(
        persons: [
          createPerson(
            id: 'u12',
            name: 'na1',
            surname: 'su1',
            coachId: loggedUserId,
          ),
          createPerson(id: 'u2', name: 'na2', surname: 'su2'),
          createPerson(id: 'u3', name: 'na3', surname: 'su3'),
          createPerson(id: 'u4', name: 'na4', surname: 'su4', coachId: 'c1'),
          createPerson(id: 'u5', name: 'na4', surname: 'su4', coachId: 'c2'),
        ],
      );
    },
    act: (cubit) async {
      cubit.initialize();
      await cubit.stream.first;
      cubit.search('sea');
    },
    expect: () => [
      const PersonsSearchState(status: CubitStatusComplete()),
      const PersonsSearchState(status: CubitStatusLoading()),
      PersonsSearchState(
        status: const CubitStatusComplete(),
        searchQuery: 'sea',
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
            relationshipStatus: RelationshipStatus.pending,
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
          FoundPerson(
            info: createPerson(
              id: 'u5',
              name: 'na4',
              surname: 'su4',
              coachId: 'c2',
            ),
            relationshipStatus: RelationshipStatus.accepted,
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
    'client to coach direction, '
    'should call person repository method to search persons and '
    'should update found persons in state',
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.clientToCoach,
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: loggedUserId);
      userRepository.mockGetUserById(user: createUser(coachId: 'u5'));
      personRepository.mockGetPersonsByCoachId(
        persons: [createPerson(id: 'u12')],
      );
      coachingRequestService.mockGetCoachingRequestsBySenderId(
        requests: [createCoachingRequest(receiverId: 'u2', isAccepted: false)],
      );
      coachingRequestService.mockGetCoachingRequestsByReceiverId(
        requests: [createCoachingRequest(senderId: 'u3', isAccepted: false)],
      );
      personRepository.mockSearchForPersons(
        persons: [
          createPerson(id: 'u12', name: 'na1', surname: 'su1'),
          createPerson(id: 'u2', name: 'na2', surname: 'su2', coachId: 'c1'),
          createPerson(id: 'u3', name: 'na3', surname: 'su3', coachId: 'c2'),
          createPerson(id: 'u4', name: 'na4', surname: 'su4', coachId: 'c1'),
          createPerson(id: 'u5', name: 'na4', surname: 'su4', coachId: 'c2'),
        ],
      );
    },
    act: (cubit) async {
      cubit.initialize();
      await cubit.stream.first;
      cubit.search('sea');
    },
    expect: () => [
      const PersonsSearchState(status: CubitStatusComplete()),
      const PersonsSearchState(status: CubitStatusLoading()),
      PersonsSearchState(
        status: const CubitStatusComplete(),
        searchQuery: 'sea',
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
            relationshipStatus: RelationshipStatus.pending,
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
          FoundPerson(
            info: createPerson(
              id: 'u5',
              name: 'na4',
              surname: 'su4',
              coachId: 'c2',
            ),
            relationshipStatus: RelationshipStatus.accepted,
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
      const PersonsSearchState(status: CubitStatusNoLoggedUser()),
    ],
    verify: (_) => verify(() => authService.loggedUserId$).called(1),
  );

  blocTest(
    'invite person, '
    'coach to client, '
    "should call coaching request repository's method to add request with given person id set as receiver id, coachToClient direction and pending invitation status",
    build: () => PersonsSearchCubit(
      requestDirection: CoachingRequestDirection.coachToClient,
      initialState: const PersonsSearchState(status: CubitStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest();
    },
    act: (cubit) => cubit.invitePerson('u2'),
    expect: () => [
      const PersonsSearchState(status: CubitStatusLoading()),
      const PersonsSearchState(
        status: CubitStatusComplete<PersonsSearchCubitInfo>(
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
      initialState: const PersonsSearchState(status: CubitStatusComplete()),
    ),
    setUp: () {
      authService.mockGetLoggedUserId(userId: 'u1');
      coachingRequestService.mockAddCoachingRequest();
    },
    act: (cubit) => cubit.invitePerson('u2'),
    expect: () => [
      const PersonsSearchState(status: CubitStatusLoading()),
      const PersonsSearchState(
        status: CubitStatusComplete<PersonsSearchCubitInfo>(
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
      initialState: const PersonsSearchState(status: CubitStatusComplete()),
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
      const PersonsSearchState(status: CubitStatusLoading()),
      const PersonsSearchState(
        status: CubitStatusError<PersonsSearchCubitError>(
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
