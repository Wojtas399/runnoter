import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/cubit_status.dart';
import '../../../data/entity/user.dart';
import '../../../data/interface/repository/user_repository.dart';
import '../../../data/interface/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/settings.dart';

part 'home_state.dart';

class HomeCubit extends CubitWithStatus<HomeState, HomeCubitInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  StreamSubscription<User?>? _loggedUserListener;

  HomeCubit({
    HomeState initialState = const HomeState(status: CubitStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _loggedUserListener?.cancel();
    return super.close();
  }

  void initialize() {
    emitLoadingStatus();
    _loggedUserListener ??= _authService.loggedUserId$
        .switchMap(
          (String? loggedUserId) => loggedUserId == null
              ? Stream.value(null)
              : _userRepository.getUserById(userId: loggedUserId),
        )
        .listen(
          (User? loggedUser) => emit(state.copyWith(
            status: loggedUser == null ? const CubitStatusNoLoggedUser() : null,
            accountType: loggedUser?.accountType,
            loggedUserName: loggedUser?.name,
            appSettings: loggedUser?.settings,
          )),
        );
  }

  Future<void> signOut() async {
    emitLoadingStatus();
    await _authService.signOut();
    emitCompleteStatus(info: HomeCubitInfo.userSignedOut);
  }
}

enum HomeCubitInfo { userSignedOut }
