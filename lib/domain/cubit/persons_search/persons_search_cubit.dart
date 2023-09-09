import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/custom_exception.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'persons_search_state.dart';

class PersonsSearchCubit extends CubitWithStatus<PersonsSearchState,
    PersonsSearchCubitInfo, PersonsSearchCubitError> {
  final AuthService _authService;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;
  final CoachingRequestDirection requestDirection;
  StreamSubscription<_ListenedParams>? _listener;

  PersonsSearchCubit({
    required this.requestDirection,
    PersonsSearchState initialState = const PersonsSearchState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _listener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _getClientIds(loggedUserId),
            _coachingRequestService
                .getCoachingRequestsBySenderId(
                  senderId: loggedUserId,
                  direction: requestDirection,
                )
                .whereNotNull(),
            (
              List<String> clientIds,
              List<CoachingRequest> sentCoachingRequests,
            ) =>
                _ListenedParams(
              clientIds: clientIds,
              sentCoachingRequests: sentCoachingRequests,
            ),
          ),
        )
        .listen(
      (_ListenedParams params) {
        final clientIds = {
          ...params.clientIds,
          ...params.sentCoachingRequests.clientIds,
        }.toList();
        final invitedPersonIds = params.sentCoachingRequests.invitedUserIds;
        emit(state.copyWith(
          clientIds: clientIds,
          invitedPersonIds: invitedPersonIds,
          foundPersons: state.foundPersons != null
              ? _updateFoundPersons(clientIds, invitedPersonIds)
              : null,
        ));
      },
    );
  }

  Future<void> search(String searchQuery) async {
    if (searchQuery.isEmpty) {
      emit(state.copyWith(
        status: const CubitStatusComplete(),
        searchQuery: searchQuery,
        setFoundPersonsAsNull: true,
      ));
      return;
    }
    emitLoadingStatus();
    final List<Person> foundPersons = await _personRepository.searchForPersons(
      searchQuery: searchQuery,
      accountType: requestDirection == CoachingRequestDirection.clientToCoach
          ? AccountType.coach
          : null,
    );
    emit(state.copyWith(
      searchQuery: searchQuery,
      foundPersons: foundPersons
          .map(
            (Person person) => FoundPerson(
              info: person,
              relationshipStatus: _selectRelationshipStatus(
                person: person,
                clientIds: state.clientIds,
                invitedPersonIds: state.invitedPersonIds,
              ),
            ),
          )
          .toList(),
    ));
  }

  Future<void> invitePerson(String personId) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    try {
      await _coachingRequestService.addCoachingRequest(
        senderId: loggedUserId,
        receiverId: personId,
        direction: requestDirection,
        isAccepted: false,
      );
      emitCompleteStatus(info: PersonsSearchCubitInfo.requestSent);
    } on CoachingRequestException catch (exception) {
      if (exception.code == CoachingRequestExceptionCode.userAlreadyHasCoach) {
        emitErrorStatus(PersonsSearchCubitError.userAlreadyHasCoach);
      } else {
        rethrow;
      }
    }
  }

  Stream<List<String>> _getClientIds(String loggedUserId) => _personRepository
      .getPersonsByCoachId(coachId: loggedUserId)
      .map((persons) => [...?persons?.map((person) => person.id)]);

  List<FoundPerson> _updateFoundPersons(
    List<String> clientIds,
    List<String> invitedPersonIds,
  ) {
    final List<FoundPerson> updatedFoundPersons = [];
    for (final foundPerson in [...?state.foundPersons]) {
      final RelationshipStatus status = _selectRelationshipStatus(
        person: foundPerson.info,
        clientIds: clientIds,
        invitedPersonIds: invitedPersonIds,
      );
      updatedFoundPersons.add(foundPerson.copyWithStatus(status));
    }
    return updatedFoundPersons;
  }

  RelationshipStatus _selectRelationshipStatus({
    required Person person,
    required List<String> clientIds,
    required List<String> invitedPersonIds,
  }) {
    if (clientIds.contains(person.id)) {
      return RelationshipStatus.accepted;
    } else if (requestDirection == CoachingRequestDirection.coachToClient &&
        person.coachId != null) {
      return RelationshipStatus.alreadyTaken;
    } else if (invitedPersonIds.contains(person.id)) {
      return RelationshipStatus.pending;
    } else {
      return RelationshipStatus.notInvited;
    }
  }
}

enum PersonsSearchCubitInfo { requestSent }

enum PersonsSearchCubitError { userAlreadyHasCoach }

class _ListenedParams extends Equatable {
  final List<String> clientIds;
  final List<CoachingRequest> sentCoachingRequests;

  const _ListenedParams({
    required this.clientIds,
    required this.sentCoachingRequests,
  });

  @override
  List<Object?> get props => [clientIds, sentCoachingRequests];
}

extension _CoachingRequestsExtensions on List<CoachingRequest> {
  List<String> get clientIds =>
      where((coachingRequest) => coachingRequest.isAccepted)
          .map((coachingRequest) => coachingRequest.receiverId)
          .toList();

  List<String> get invitedUserIds =>
      where((coachingRequest) => !coachingRequest.isAccepted)
          .map((coachingRequest) => coachingRequest.receiverId)
          .toList();
}
