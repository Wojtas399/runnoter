import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/custom_exception.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/person_repository.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'persons_search_state.dart';

class PersonsSearchCubit extends CubitWithStatus<PersonsSearchState,
    PersonsSearchCubitInfo, PersonsSearchCubitError> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final PersonRepository _personRepository;
  final CoachingRequestService _coachingRequestService;
  final CoachingRequestDirection requestDirection;
  StreamSubscription<PersonsSearchState>? _listener;
  String? _loggedUserCoachId;
  List<String> _clientIds = const [];
  List<String> _inviteeIds = const [];
  List<String> _inviterIds = const [];

  PersonsSearchCubit({
    required this.requestDirection,
    PersonsSearchState initialState = const PersonsSearchState(
      status: CubitStatusInitial(),
    ),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _personRepository = getIt<PersonRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _listener ??= _authService.loggedUserId$.switchMap(
      (String? loggedUserId) {
        if (loggedUserId == null) return Stream.value(state.copyWith());
        return Rx.combineLatest4(
          _userRepository.getUserById(userId: loggedUserId),
          _getClientIds(loggedUserId),
          _getSentCoachingReqs(loggedUserId),
          _getReceivedCoachingReqs(loggedUserId),
          (
            User? loggedUser,
            List<String> clientIds,
            List<CoachingRequest> sentReqs,
            List<CoachingRequest> receivedReqs,
          ) {
            _loggedUserCoachId = loggedUser?.coachId;
            _clientIds = {
              ...clientIds,
              ...sentReqs.acceptedReqReceiverIds,
              ...receivedReqs.acceptedReqSenderIds,
            }.toList();
            _inviteeIds = sentReqs.unacceptedReqReceiverIds;
            _inviterIds = receivedReqs.unacceptedReqSenderIds;
            return state.copyWith(
              foundPersons: _updateRelationshipStatusesOfFoundPersons(),
            );
          },
        );
      },
    ).listen(emit);
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
              relationshipStatus: _adjustRelationshipStatusToPerson(person),
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

  Stream<List<CoachingRequest>> _getSentCoachingReqs(String loggedUserId) =>
      _coachingRequestService.getCoachingRequestsBySenderId(
        senderId: loggedUserId,
        direction: requestDirection,
      );

  Stream<List<CoachingRequest>> _getReceivedCoachingReqs(String loggedUserId) =>
      _coachingRequestService.getCoachingRequestsByReceiverId(
        receiverId: loggedUserId,
        direction: _getOppositeRequestDirection(requestDirection),
      );

  RelationshipStatus _adjustRelationshipStatusToPerson(Person person) {
    final String personId = person.id;
    final bool isPersonCoachOfLoggedUser = _loggedUserCoachId == personId;
    final bool isPersonClientOfLoggedUser = _clientIds.contains(personId);
    if (isPersonClientOfLoggedUser || isPersonCoachOfLoggedUser) {
      return RelationshipStatus.accepted;
    } else if (requestDirection == CoachingRequestDirection.coachToClient &&
        person.coachId != null) {
      return RelationshipStatus.alreadyTaken;
    } else if (_inviteeIds.contains(personId) ||
        _inviterIds.contains(personId)) {
      return RelationshipStatus.pending;
    } else {
      return RelationshipStatus.notInvited;
    }
  }

  CoachingRequestDirection _getOppositeRequestDirection(
    CoachingRequestDirection direction,
  ) =>
      switch (requestDirection) {
        CoachingRequestDirection.coachToClient =>
          CoachingRequestDirection.clientToCoach,
        CoachingRequestDirection.clientToCoach =>
          CoachingRequestDirection.coachToClient,
      };

  List<FoundPerson>? _updateRelationshipStatusesOfFoundPersons() {
    if (state.foundPersons == null) return null;
    final List<FoundPerson> updatedFoundPersons = [];
    for (final foundPerson in [...?state.foundPersons]) {
      final RelationshipStatus relationshipStatus =
          _adjustRelationshipStatusToPerson(foundPerson.info);
      updatedFoundPersons.add(
        foundPerson.copyWithRelationshipStatus(relationshipStatus),
      );
    }
    return updatedFoundPersons;
  }
}

enum PersonsSearchCubitInfo { requestSent }

enum PersonsSearchCubitError { userAlreadyHasCoach }

extension _CoachingRequestsExtensions on List<CoachingRequest> {
  Iterable<CoachingRequest> get _acceptedReqs => where((req) => req.isAccepted);

  Iterable<CoachingRequest> get _unacceptedReqs =>
      where((req) => !req.isAccepted);

  List<String> get acceptedReqReceiverIds =>
      _acceptedReqs.map((req) => req.receiverId).toList();

  List<String> get acceptedReqSenderIds =>
      _acceptedReqs.map((req) => req.senderId).toList();

  List<String> get unacceptedReqReceiverIds =>
      _unacceptedReqs.map((req) => req.receiverId).toList();

  List<String> get unacceptedReqSenderIds =>
      _unacceptedReqs.map((req) => req.senderId).toList();
}
