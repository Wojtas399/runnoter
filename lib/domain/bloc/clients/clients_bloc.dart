import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../entity/person.dart';
import '../../repository/person_repository.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends BlocWithStatus<ClientsEvent, ClientsState,
    ClientsBlocInfo, dynamic> {
  final AuthService _authService;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;
  final UserRepository _userRepository;

  ClientsBloc({
    ClientsState state = const ClientsState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        _userRepository = getIt<UserRepository>(),
        super(state) {
    on<ClientsEventInitializeRequests>(_initializeRequests);
    on<ClientsEventInitializeClients>(_initializeClients);
    on<ClientsEventAcceptRequest>(_acceptRequest);
    on<ClientsEventDeleteRequest>(_deleteRequest);
    on<ClientsEventDeleteClient>(_deleteClient);
  }

  Future<void> _initializeRequests(
    ClientsEventInitializeRequests event,
    Emitter<ClientsState> emit,
  ) async {
    final Stream<(List<CoachingRequestDetails>, List<CoachingRequestDetails>)>
        requests$ =
        _getLoggedUserId().switchMap((String loggedUserId) => Rx.combineLatest2(
              _getSentRequestDetails(loggedUserId),
              _getReceivedRequestDetails(loggedUserId),
              (sentReqs, receivedReqs) => (sentReqs, receivedReqs),
            ));
    await emit.forEach(
      requests$,
      onData: ((
                List<CoachingRequestDetails>,
                List<CoachingRequestDetails>
              ) requests) =>
          state.copyWith(
        sentRequests: requests.$1,
        receivedRequests: requests.$2,
      ),
    );
  }

  Future<void> _initializeClients(
    ClientsEventInitializeClients event,
    Emitter<ClientsState> emit,
  ) async {
    final Stream<List<Person>> clients$ = _getLoggedUserId()
        .switchMap((String loggedUserId) => _getClients(loggedUserId));
    await emit.forEach(
      clients$,
      onData: (clients) => state.copyWith(clients: clients),
    );
  }

  Future<void> _acceptRequest(
    ClientsEventAcceptRequest event,
    Emitter<ClientsState> emit,
  ) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    emitLoadingStatus(emit);
    final String senderId = state.receivedRequests!
        .firstWhere((req) => req.id == event.requestId)
        .personToDisplay
        .id;
    await _userRepository.updateUser(userId: senderId, coachId: loggedUserId);
    await _coachingRequestService.updateCoachingRequest(
      requestId: event.requestId,
      isAccepted: true,
    );
    emitCompleteStatus(emit, info: ClientsBlocInfo.requestAccepted);
  }

  Future<void> _deleteRequest(
    ClientsEventDeleteRequest event,
    Emitter<ClientsState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _coachingRequestService.deleteCoachingRequest(
      requestId: event.requestId,
    );
    emitCompleteStatus(emit, info: ClientsBlocInfo.requestDeleted);
  }

  Future<void> _deleteClient(
    ClientsEventDeleteClient event,
    Emitter<ClientsState> emit,
  ) async {
    emitLoadingStatus(emit);
    await _personRepository.removeCoachOfPerson(personId: event.clientId);
    emitCompleteStatus(emit, info: ClientsBlocInfo.clientDeleted);
  }

  Stream<String> _getLoggedUserId() =>
      _authService.loggedUserId$.whereNotNull();

  Stream<List<Person>> _getClients(String loggedUserId) => _personRepository
      .getPersonsByCoachId(coachId: loggedUserId)
      .map((List<Person>? clients) => [...?clients]);

  Stream<List<CoachingRequestDetails>> _getSentRequestDetails(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((sentRequests) => sentRequests.where((req) => !req.isAccepted))
          .map(
            (pendingSentRequests) => pendingSentRequests.map(
              (req) => Rx.combineLatest2(
                Stream.value(req.id),
                _personRepository
                    .getPersonById(personId: req.receiverId)
                    .whereNotNull(),
                (requestId, receiver) => (requestId, receiver),
              ),
            ),
          )
          .switchMap(_createRequestDetailsFromStreams);

  Stream<List<CoachingRequestDetails>> _getReceivedRequestDetails(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((requests) => requests.where((req) => !req.isAccepted))
          .map(
            (pendingRequests) => pendingRequests.map(
              (req) => Rx.combineLatest2(
                Stream.value(req.id),
                _personRepository
                    .getPersonById(personId: req.senderId)
                    .whereNotNull(),
                (requestId, sender) => (requestId, sender),
              ),
            ),
          )
          .switchMap(_createRequestDetailsFromStreams);

  Stream<List<CoachingRequestDetails>> _createRequestDetailsFromStreams(
    Iterable<Stream<(String, Person)>> streams,
  ) =>
      streams.isEmpty
          ? Stream.value([])
          : Rx.combineLatest(
              streams,
              (List<(String, Person)> values) => values
                  .map(
                    (requestDetails) => CoachingRequestDetails(
                      id: requestDetails.$1,
                      personToDisplay: requestDetails.$2,
                    ),
                  )
                  .toList(),
            );
}

enum ClientsBlocInfo { requestAccepted, requestDeleted, clientDeleted }
