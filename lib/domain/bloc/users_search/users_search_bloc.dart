import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/custom_exception.dart';
import '../../entity/person.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'users_search_event.dart';
part 'users_search_state.dart';

class UsersSearchBloc extends BlocWithStatus<UsersSearchEvent, UsersSearchState,
    UsersSearchBlocInfo, UsersSearchBlocError> {
  final AuthService _authService;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;

  UsersSearchBloc({
    UsersSearchState state = const UsersSearchState(
      status: BlocStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(state) {
    on<UsersSearchEventInitialize>(_initialize);
    on<UsersSearchEventSearch>(_search);
    on<UsersSearchEventInviteUser>(_inviteUser);
  }

  Future<void> _initialize(
    UsersSearchEventInitialize event,
    Emitter<UsersSearchState> emit,
  ) async {
    final stream$ = _authService.loggedUserId$.whereNotNull().switchMap(
          (String loggedUserId) => Rx.combineLatest2(
            _getClientIds(loggedUserId),
            _coachingRequestService
                .getCoachingRequestsBySenderId(senderId: loggedUserId)
                .whereNotNull(),
            (
              List<String> clientIds,
              List<CoachingRequest> sentCoachingRequests,
            ) =>
                (clientIds, sentCoachingRequests),
          ),
        );
    await emit.forEach(
      stream$,
      onData: ((List<String>, List<CoachingRequest>) data) {
        final clientIds = {...data.$1, ...data.$2.clientIds}.toList();
        final invitedPersonIds = data.$2.invitedUserIds;
        return state.copyWith(
          clientIds: clientIds,
          invitedPersonIds: invitedPersonIds,
          foundPersons: state.foundPersons != null
              ? _updateFoundPersons(clientIds, invitedPersonIds)
              : null,
        );
      },
    );
  }

  Future<void> _search(
    UsersSearchEventSearch event,
    Emitter<UsersSearchState> emit,
  ) async {
    if (event.searchQuery.isEmpty) {
      emit(state.copyWith(
        status: const BlocStatusComplete(),
        searchQuery: event.searchQuery,
        setFoundPersonsAsNull: true,
      ));
      return;
    }
    emitLoadingStatus(emit);
    final List<Person> foundPersons = await _personRepository.searchForPersons(
      searchQuery: event.searchQuery,
    );
    emit(state.copyWith(
      searchQuery: event.searchQuery,
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

  Future<void> _inviteUser(
    UsersSearchEventInviteUser event,
    Emitter<UsersSearchState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    try {
      await _coachingRequestService.addCoachingRequest(
        senderId: loggedUserId,
        receiverId: event.idOfUserToInvite,
        status: CoachingRequestStatus.pending,
      );
      emitCompleteStatus(emit, info: UsersSearchBlocInfo.requestSent);
    } on CoachingRequestException catch (exception) {
      if (exception.code == CoachingRequestExceptionCode.userAlreadyHasCoach) {
        emitErrorStatus(emit, UsersSearchBlocError.userAlreadyHasCoach);
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
    } else if (person.coachId != null) {
      return RelationshipStatus.alreadyTaken;
    } else if (invitedPersonIds.contains(person.id)) {
      return RelationshipStatus.pending;
    } else {
      return RelationshipStatus.notInvited;
    }
  }
}

enum UsersSearchBlocInfo { requestSent }

enum UsersSearchBlocError { userAlreadyHasCoach }

extension _CoachingRequestsExtensions on List<CoachingRequest> {
  List<String> get clientIds => where((coachingRequest) =>
          coachingRequest.status == CoachingRequestStatus.accepted)
      .map((coachingRequest) => coachingRequest.receiverId)
      .toList();

  List<String> get invitedUserIds => where((coachingRequest) =>
          coachingRequest.status == CoachingRequestStatus.pending)
      .map((coachingRequest) => coachingRequest.receiverId)
      .toList();
}
