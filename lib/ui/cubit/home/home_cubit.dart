import 'dart:async';

import 'package:rxdart/rxdart.dart';

import '../../../data/model/user.dart';
import '../../../data/repository/user/user_repository.dart';
import '../../../data/service/auth/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../model/cubit_state.dart';
import '../../model/cubit_status.dart';
import '../../model/cubit_with_status.dart';

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
            accountType: loggedUser?.accountType,
            loggedUserName: loggedUser?.name,
            hasLoggedUserCoach: loggedUser?.coachId != null,
            userSettings: loggedUser?.settings,
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
