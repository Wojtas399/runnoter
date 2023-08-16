import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/coaching_request_short.dart';
import '../../entity/person.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'clients_event.dart';
part 'clients_state.dart';

class ClientsBloc extends BlocWithStatus<ClientsEvent, ClientsState,
    ClientsBlocInfo, dynamic> {
  final AuthService _authService;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;

  ClientsBloc({
    ClientsState state = const ClientsState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        super(state) {
    on<ClientsEventInitialize>(_initialize, transformer: restartable());
    on<ClientsEventAcceptRequest>(_acceptRequest);
    on<ClientsEventDeleteRequest>(_deleteRequest);
    on<ClientsEventDeleteClient>(_deleteClient);
  }

  Future<void> _initialize(
    ClientsEventInitialize event,
    Emitter<ClientsState> emit,
  ) async {
    final Stream<ClientsBlocListenedParams> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest3(
                _getSentRequests(loggedUserId),
                _getReceivedRequests(loggedUserId),
                _getClients(loggedUserId),
                (
                  List<CoachingRequestShort> sentRequests,
                  List<CoachingRequestShort> receivedRequests,
                  List<Person> clients,
                ) =>
                    ClientsBlocListenedParams(
                  sentRequests: sentRequests,
                  receivedRequests: receivedRequests,
                  clients: clients,
                ),
              ),
            );
    await emit.forEach(
      stream$,
      onData: (ClientsBlocListenedParams params) => state.copyWith(
        sentRequests: params.sentRequests,
        receivedRequests: params.receivedRequests,
        clients: params.clients,
      ),
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
    await _personRepository.updateCoachIdOfPerson(
      personId: senderId,
      coachId: loggedUserId,
    );
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
    await _personRepository.updateCoachIdOfPerson(
      personId: event.clientId,
      coachId: null,
    );
    emitCompleteStatus(emit, info: ClientsBlocInfo.clientDeleted);
  }

  Stream<List<Person>> _getClients(String loggedUserId) => _personRepository
      .getPersonsByCoachId(coachId: loggedUserId)
      .map((List<Person>? clients) => [...?clients]);

  Stream<List<CoachingRequestShort>> _getSentRequests(String loggedUserId) =>
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
          .switchMap(_createShortRequestsFromStreams);

  Stream<List<CoachingRequestShort>> _getReceivedRequests(
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
          .switchMap(_createShortRequestsFromStreams);

  Stream<List<CoachingRequestShort>> _createShortRequestsFromStreams(
    Iterable<Stream<(String, Person)>> streams,
  ) =>
      streams.isEmpty
          ? Stream.value([])
          : Rx.combineLatest(
              streams,
              (List<(String, Person)> values) => values
                  .map(
                    (req) => CoachingRequestShort(
                      id: req.$1,
                      personToDisplay: req.$2,
                    ),
                  )
                  .toList(),
            );
}

enum ClientsBlocInfo { requestAccepted, requestDeleted, clientDeleted }

class ClientsBlocListenedParams extends Equatable {
  final List<CoachingRequestShort> sentRequests;
  final List<CoachingRequestShort> receivedRequests;
  final List<Person> clients;

  const ClientsBlocListenedParams({
    required this.sentRequests,
    required this.receivedRequests,
    required this.clients,
  });

  @override
  List<Object?> get props => [sentRequests, receivedRequests, clients];
}
