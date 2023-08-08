import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';

class ClientsCubit extends Cubit<List<Client>?> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<List<User>?>? _listener;

  ClientsCubit({List<Client>? clients})
      : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
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
          (String loggedUserId) => _userRepository.getUsersByCoachId(
            coachId: loggedUserId,
          ),
        )
        .listen(_clientsChanged);
  }

  void _clientsChanged(List<User>? users) {
    final List<Client>? clients = users
        ?.map(
          (User user) => Client(
            id: user.id,
            gender: user.gender,
            name: user.name,
            surname: user.surname,
            email: user.email,
          ),
        )
        .toList();
    clients?.sort((c1, c2) => c1.surname.compareTo(c2.surname));
    emit(clients);
  }
}

class Client extends Equatable {
  final String id;
  final Gender gender;
  final String name;
  final String surname;
  final String email;

  const Client({
    required this.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, email];
}
