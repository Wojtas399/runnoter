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

class ClientsBloc
    extends BlocWithStatus<ClientsEvent, ClientsState, dynamic, dynamic> {
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
  }

  Future<void> _initialize(
    ClientsEventInitialize event,
    Emitter<ClientsState> emit,
  ) async {
    final Stream<(List<InvitedPerson>, List<Person>)> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _getInvitedPersons(loggedUserId),
                _getClients(loggedUserId),
                (invitedPersons, clients) => (invitedPersons, clients),
              ),
            );
    await emit.forEach(
      stream$,
      onData: ((List<InvitedPerson>, List<Person>) data) => state.copyWith(
        invitedPersons: data.$1,
        clients: data.$2,
      ),
    );
  }

  Stream<List<InvitedPerson>> _getInvitedPersons(String loggedUserId) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(senderId: loggedUserId)
          .map(
            (List<CoachingRequest> requests) => requests.map(_getInvitedPerson),
          )
          .switchMap(
            (invitedPersons$) => Rx.combineLatest(
              invitedPersons$,
              (List<InvitedPerson> invitedPersons) => invitedPersons,
            ),
          );

  Stream<List<Person>> _getClients(String loggedUserId) => _personRepository
      .getPersonsByCoachId(coachId: loggedUserId)
      .map((List<Person>? clients) => [...?clients]);

  Stream<InvitedPerson> _getInvitedPerson(CoachingRequest request) =>
      _personRepository
          .getPersonById(personId: request.receiverId)
          .whereNotNull()
          .map(
            (Person person) => InvitedPerson(
              coachingRequestId: request.id,
              person: person,
            ),
          );
}
