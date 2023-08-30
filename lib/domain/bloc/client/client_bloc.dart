import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/person_repository.dart';

part 'client_event.dart';
part 'client_state.dart';

class ClientBloc
    extends BlocWithStatus<ClientEvent, ClientState, dynamic, dynamic> {
  final String clientId;
  final PersonRepository _personRepository;

  ClientBloc({
    required this.clientId,
    ClientState state = const ClientState(
      status: BlocStatusInitial(),
    ),
  })  : _personRepository = getIt<PersonRepository>(),
        super(state) {
    on<ClientEventInitialize>(_initialize, transformer: restartable());
  }

  Future<void> _initialize(
    ClientEventInitialize event,
    Emitter<ClientState> emit,
  ) async {
    final Stream<Person?> client$ =
        _personRepository.getPersonById(personId: clientId);
    await emit.forEach(
      client$,
      onData: (Person? client) => state.copyWith(
        gender: client?.gender,
        name: client?.name,
        surname: client?.surname,
        email: client?.email,
      ),
    );
  }
}
