import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/entity/person.dart';
import '../../../data/interface/repository/person_repository.dart';
import '../../../data/interface/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../use_case/load_chat_id_use_case.dart';

part 'client_state.dart';

class ClientCubit extends Cubit<ClientState> {
  final String clientId;
  final AuthService _authService;
  final PersonRepository _personRepository;
  final LoadChatIdUseCase _loadChatIdUseCase;
  StreamSubscription<Person?>? _clientListener;

  ClientCubit({required this.clientId})
      : _authService = getIt<AuthService>(),
        _personRepository = getIt<PersonRepository>(),
        _loadChatIdUseCase = getIt<LoadChatIdUseCase>(),
        super(const ClientState());

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
                  name: client?.name,
                  surname: client?.surname,
                ),
              ),
            );
  }

  Future<String?> loadChatId() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) return null;
    return await _loadChatIdUseCase.execute(
      user1Id: loggedUserId,
      user2Id: clientId,
    );
  }
}
