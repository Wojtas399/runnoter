import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../entity/person.dart';
import '../repository/person_repository.dart';
import '../service/auth_service.dart';

class ClientsCubit extends Cubit<List<Person>?> {
  final AuthService _authService;
  final PersonRepository _personRepository;
  StreamSubscription<List<Person>?>? _listener;

  ClientsCubit({List<Person>? clients})
      : _authService = getIt<AuthService>(),
        _personRepository = getIt<PersonRepository>(),
        super(clients);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  void initialize() {
    _listener = _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (loggedUserId) => _personRepository.getPersonsByCoachId(
            coachId: loggedUserId,
          ),
        )
        .listen((List<Person>? persons) => emit(persons));
  }
}
