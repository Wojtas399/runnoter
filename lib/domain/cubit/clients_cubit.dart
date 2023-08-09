import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../additional_model/user_basic_info.dart';
import '../entity/user.dart';
import '../repository/user_repository.dart';
import '../service/auth_service.dart';

class ClientsCubit extends Cubit<List<UserBasicInfo>?> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<List<User>?>? _listener;

  ClientsCubit({List<UserBasicInfo>? clients})
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
    final List<UserBasicInfo>? clients = users
        ?.map(
          (User user) => UserBasicInfo(
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
