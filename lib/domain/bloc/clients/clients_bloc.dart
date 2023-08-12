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
    on<ClientsEventInitialize>(_initialize);
    on<ClientsEventDeleteRequest>(_deleteRequest);
    on<ClientsEventDeleteClient>(_deleteClient);
  }

  Future<void> _initialize(
    ClientsEventInitialize event,
    Emitter<ClientsState> emit,
  ) async {
    final Stream<(List<SentCoachingRequest>, List<Person>)> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _getSentRequests(loggedUserId),
                _getClients(loggedUserId),
                (invitedPersons, clients) => (invitedPersons, clients),
              ),
            );
    await emit.forEach(
      stream$,
      onData: ((List<SentCoachingRequest>, List<Person>) data) =>
          state.copyWith(sentRequests: data.$1, clients: data.$2),
    );
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

  Stream<List<SentCoachingRequest>> _getSentRequests(String loggedUserId) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(senderId: loggedUserId)
          .map((requests) => requests.where((request) => !request.isAccepted))
          .map((pendingRequests) => pendingRequests.map(_mapToSentRequest))
          .doOnData(
            (_) => _personRepository.refreshPersonsByCoachId(
              coachId: loggedUserId,
            ),
          )
          .switchMap(
            (sentRequests$) => sentRequests$.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(
                    sentRequests$,
                    (List<SentCoachingRequest> sentRequests) => sentRequests,
                  ),
          );

  Stream<List<Person>> _getClients(String loggedUserId) => _personRepository
      .getPersonsByCoachId(coachId: loggedUserId)
      .map((List<Person>? clients) => [...?clients]);

  Stream<SentCoachingRequest> _mapToSentRequest(CoachingRequest request) =>
      _personRepository
          .getPersonById(personId: request.receiverId)
          .whereNotNull()
          .map(
            (Person person) => SentCoachingRequest(
              requestId: request.id,
              receiver: person,
            ),
          );
}

enum ClientsBlocInfo { requestDeleted, clientDeleted }
