import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/model/settings.dart';
import '../../../domain/model/user.dart';
import '../../../domain/repository/user_repository.dart';
import '../../../domain/service/auth_service.dart';

class DistanceUnitCubit extends Cubit<DistanceUnit?> {
  final AuthService _authService;
  final UserRepository _userRepository;

  DistanceUnitCubit({
    required AuthService authService,
    required UserRepository userRepository,
    DistanceUnit? distanceUnit,
  })  : _authService = authService,
        _userRepository = userRepository,
        super(distanceUnit);

  Future<void> initialize() async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    final User? user =
        await _userRepository.getUserById(userId: loggedUserId).first;
    emit(user?.settings.distanceUnit);
  }

  Future<void> updateDistanceUnit({
    required DistanceUnit distanceUnit,
  }) async {
    final String? loggedUserId = await _authService.loggedUserId$.first;
    if (loggedUserId == null) {
      return;
    }
    final DistanceUnit? previousDistanceUnit = state;
    emit(distanceUnit);
    try {
      await _userRepository.updateUserSettings(
        userId: loggedUserId,
        distanceUnit: distanceUnit,
      );
    } catch (_) {
      emit(previousDistanceUnit);
    }
  }
}
