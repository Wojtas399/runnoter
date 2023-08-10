import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/user_basic_info.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';
import '../../service/auth_service.dart';
import '../../service/coaching_request_service.dart';

part 'coach_event.dart';
part 'coach_state.dart';

class CoachBloc
    extends BlocWithStatus<CoachEvent, CoachState, dynamic, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final CoachingRequestService _coachingRequestService;

  CoachBloc({
    CoachState state = const CoachState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        super(state) {
    on<CoachEventInitialize>(_initialize);
  }

  Future<void> _initialize(
    CoachEventInitialize event,
    Emitter<CoachState> emit,
  ) async {
    final Stream stream$ = _getLoggedUserData().map(
      (User loggedUser) => loggedUser.coachId != null
          ? _getCoach(loggedUser.coachId!)
          : _coachingRequestService.getCoachingRequestsByReceiverId(
              receiverId: loggedUser.id,
            ),
    );
    await emit.forEach(
      stream$,
      onData: (data) {
        if (data is UserBasicInfo) {
          return CoachState(status: const BlocStatusComplete(), coach: data);
        } else if (data is List<CoachingRequest>) {
          return CoachState(
            status: const BlocStatusComplete(),
            receivedCoachingRequests: data,
          );
        }
        return const CoachState(status: BlocStatusComplete());
      },
    );
  }

  Stream<User> _getLoggedUserData() => _authService.loggedUserId$
      .whereNotNull()
      .switchMap(
        (loggedUserId) => _userRepository.getUserById(userId: loggedUserId),
      )
      .whereNotNull();

  Stream<UserBasicInfo?> _getCoach(String coachId) =>
      _userRepository.getUserById(userId: coachId).map(
            (User? coachData) => coachData != null
                ? UserBasicInfo(
                    id: coachData.id,
                    gender: coachData.gender,
                    name: coachData.name,
                    surname: coachData.surname,
                    email: coachData.email,
                  )
                : null,
          );
}
