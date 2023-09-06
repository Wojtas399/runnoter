import 'dart:async';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../entity/person.dart';
import '../../entity/user.dart';
import '../../repository/person_repository.dart';

part 'client_state.dart';

class ClientCubit extends CubitWithStatus<ClientState, dynamic, dynamic> {
  final String clientId;
  final PersonRepository _personRepository;
  StreamSubscription<Person?>? _clientListener;

  ClientCubit({
    required this.clientId,
    ClientState initialState = const ClientState(
      status: BlocStatusInitial(),
    ),
  })  : _personRepository = getIt<PersonRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _clientListener?.cancel();
    _clientListener = null;
    return super.close();
  }

  void initialize() {
    _clientListener ??=
        _personRepository.getPersonById(personId: clientId).listen(
              (Person? client) => emit(
                state.copyWith(
                  gender: client?.gender,
                  name: client?.name,
                  surname: client?.surname,
                  email: client?.email,
                  dateOfBirth: client?.dateOfBirth,
                ),
              ),
            );
  }
}
