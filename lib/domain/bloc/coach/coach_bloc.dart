import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../dependency_injection.dart';
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../additional_model/coaching_request.dart';
import '../../entity/user.dart';
import '../../entity/user_basic_info.dart';
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
    final Stream<(UserBasicInfo?, List<CoachingRequest>?)> stream$ =
        _authService.loggedUserId$.whereNotNull().switchMap(
              (String loggedUserId) => Rx.combineLatest2(
                _getCoach(loggedUserId),
                _coachingRequestService.getCoachingRequestsByReceiverId(
                  receiverId: loggedUserId,
                ),
                (coachInfo, receivedRequests) => (coachInfo, receivedRequests),
              ),
            );
    await emit.forEach(
      stream$,
      onData: ((UserBasicInfo?, List<CoachingRequest>?) data) => CoachState(
        status: const BlocStatusComplete(),
        coach: data.$1,
        receivedCoachingRequests: data.$1 != null ? null : data.$2,
      ),
    );
  }

  Stream<UserBasicInfo?> _getCoach(String loggedUserId) => _userRepository
      .getUserById(userId: loggedUserId)
      .whereNotNull()
      .map((User loggedUserData) => loggedUserData.coachId)
      .switchMap(
        (String? coachId) => coachId != null
            ? _userRepository.getUserById(userId: coachId)
            : Stream.value(null),
      )
      .map(
        (User? coachData) => coachData == null
            ? null
            : UserBasicInfo(
                id: coachData.id,
                gender: coachData.gender,
                name: coachData.name,
                surname: coachData.surname,
                email: coachData.email,
              ),
      );
}
