import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../dependency_injection.dart';
import '../entity/user_basic_info.dart';
import '../repository/user_basic_info_repository.dart';
import '../service/auth_service.dart';

class ClientsCubit extends Cubit<List<UserBasicInfo>?> {
  final AuthService _authService;
  final UserBasicInfoRepository _userBasicInfoRepository;
  StreamSubscription<List<UserBasicInfo>?>? _listener;

  ClientsCubit({List<UserBasicInfo>? clients})
      : _authService = getIt<AuthService>(),
        _userBasicInfoRepository = getIt<UserBasicInfoRepository>(),
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
          (loggedUserId) => _userBasicInfoRepository.getUsersBasicInfoByCoachId(
            coachId: loggedUserId,
          ),
        )
        .listen((List<UserBasicInfo>? usersBasicInfo) => emit(usersBasicInfo));
  }
}
