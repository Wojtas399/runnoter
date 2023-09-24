import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/coaching_request_short.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../entity/person.dart';
import '../../repository/person_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';
import '../../use_case/load_chat_id_use_case.dart';

part 'clients_state.dart';

class ClientsCubit
    extends CubitWithStatus<ClientsState, ClientsCubitInfo, dynamic> {
  final AuthService _authService;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;
  final LoadChatIdUseCase _loadChatIdUseCase;
  StreamSubscription<_ListenedParams>? _listener;

  ClientsCubit({
    ClientsState initialState =
        const ClientsState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        _loadChatIdUseCase = getIt<LoadChatIdUseCase>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    _listener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => Rx.combineLatest3(
            _getSentRequests(loggedUserId),
            _getReceivedRequests(loggedUserId),
            _getClients(loggedUserId),
            (
              List<CoachingRequestShort> sentRequests,
              List<CoachingRequestShort> receivedRequests,
              List<Person> clients,
            ) =>
                _ListenedParams(
              sentRequests: sentRequests,
              receivedRequests: receivedRequests,
              clients: clients,
            ),
          ),
        )
        .listen(
          (_ListenedParams params) => emit(state.copyWith(
            sentRequests: params.sentRequests,
            receivedRequests: params.receivedRequests,
            clients: params.clients,
          )),
        );
  }

  Future<void> acceptRequest(String requestId) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      emitNoLoggedUserStatus();
      return;
    }
    emitLoadingStatus();
    final String senderId = state.receivedRequests!
        .firstWhere((req) => req.id == requestId)
        .personToDisplay
        .id;
    await _personRepository.updateCoachIdOfPerson(
      personId: senderId,
      coachId: loggedUserId,
    );
    await _coachingRequestService.updateCoachingRequest(
      requestId: requestId,
      isAccepted: true,
    );
    emitCompleteStatus(info: ClientsCubitInfo.requestAccepted);
  }

  Future<void> deleteRequest(String requestId) async {
    emitLoadingStatus();
    await _coachingRequestService.deleteCoachingRequest(requestId: requestId);
    emitCompleteStatus(info: ClientsCubitInfo.requestDeleted);
  }

  Future<void> openChatWithClient(String clientId) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return;
    emitLoadingStatus();
    final String? chatId = await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: clientId,
    );
    emit(state.copyWith(selectedChatId: chatId));
  }

  Future<void> deleteClient(String clientId) async {
    emitLoadingStatus();
    await _personRepository.updateCoachIdOfPerson(
      personId: clientId,
      coachId: null,
    );
    emitCompleteStatus(info: ClientsCubitInfo.clientDeleted);
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

enum ClientsCubitInfo { requestAccepted, requestDeleted, clientDeleted }

class _ListenedParams extends Equatable {
  final List<CoachingRequestShort> sentRequests;
  final List<CoachingRequestShort> receivedRequests;
  final List<Person> clients;

  const _ListenedParams({
    required this.sentRequests,
    required this.receivedRequests,
    required this.clients,
  });

  @override
  List<Object?> get props => [sentRequests, receivedRequests, clients];
}
