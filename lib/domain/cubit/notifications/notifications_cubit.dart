import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final AuthService _authService;
  final CoachingRequestService _coachingRequestService;
  final UserRepository _userRepository;
  StreamSubscription<_ListenedParams>? _listener;

  NotificationsCubit()
      : _authService = getIt<AuthService>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _userRepository = getIt<UserRepository>(),
        super(const NotificationsState());

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }

  Future<void> initialize() async {
    final User loggedUser = await _loadLoggedUser();
    if (loggedUser.accountType == AccountType.runner) return;
    _listener ??= _getNumberOfCoachingRequestsReceivedFromClients(loggedUser.id)
        .map(
          (int numberOfCoachingRequestsReceivedFromClients) => _ListenedParams(
            numberOfCoachingRequestsReceivedFromClients:
                numberOfCoachingRequestsReceivedFromClients,
          ),
        )
        .listen(
          (_ListenedParams params) => emit(state.copyWith(
            numberOfCoachingRequestsReceivedFromClients:
                params.numberOfCoachingRequestsReceivedFromClients,
          )),
        );
  }

  Future<User> _loadLoggedUser() async => await _authService.loggedUserId$
      .whereNotNull()
      .switchMap(
        (loggedUserId) => _userRepository.getUserById(userId: loggedUserId),
      )
      .whereNotNull()
      .first;

  Stream<int> _getNumberOfCoachingRequestsReceivedFromClients(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsByReceiverId(
            receiverId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((requests) => requests.where((req) => !req.isAccepted).length);
}

class _ListenedParams extends Equatable {
  final int numberOfCoachingRequestsReceivedFromClients;

  const _ListenedParams({
    required this.numberOfCoachingRequestsReceivedFromClients,
  });

  @override
  List<Object?> get props => [numberOfCoachingRequestsReceivedFromClients];
}
