import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';

class PaceUnitCubit extends Cubit<PaceUnit?> {
  final AuthService _authService;
  final UserRepository _userRepository;

  PaceUnitCubit({
    required AuthService authService,
    required UserRepository userRepository,
    PaceUnit? paceUnit,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(paceUnit);

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    final User? user =
        await _userRepository.getUserById(userId: loggedUserId).first;
    emit(user?.settings.paceUnit);
  }

  Future<void> updatePaceUnit({
    required PaceUnit newPaceUnit,
  }) async {
    PaceUnit? currentPaceUnit, previousPaceUnit;
    currentPaceUnit = state;
    if (newPaceUnit == currentPaceUnit) {
      return;
    }
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    emit(newPaceUnit);
    previousPaceUnit = currentPaceUnit;
    currentPaceUnit = newPaceUnit;
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        paceUnit: currentPaceUnit,
      );
    } catch (_) {
      emit(previousPaceUnit);
    }
  }
}
