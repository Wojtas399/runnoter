import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/repository/user_repository.dart';
import '../../../../domain/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/coaching_request.dart';
import '../../additional_model/coaching_request_short.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/settings.dart';
import '../../entity/user.dart';
import '../../repository/person_repository.dart';
import '../../service/coaching_request_service.dart';

part 'home_state.dart';

class HomeCubit extends CubitWithStatus<HomeState, HomeCubitInfo, dynamic> {
  final AuthService _authService;
  final UserRepository _userRepository;
  final CoachingRequestService _coachingRequestService;
  final PersonRepository _personRepository;
  StreamSubscription<HomeCubitListenedParams?>? _listener;

  HomeCubit({
    HomeState initialState = const HomeState(status: BlocStatusInitial()),
  })  : _authService = getIt<AuthService>(),
        _userRepository = getIt<UserRepository>(),
        _coachingRequestService = getIt<CoachingRequestService>(),
        _personRepository = getIt<PersonRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> initialize() async {
    emitLoadingStatus();
    _listener ??= _authService.loggedUserId$
        .switchMap(
          (String? loggedUserId) => loggedUserId != null
              ? Rx.combineLatest3(
                  _userRepository.getUserById(userId: loggedUserId),
                  _getAcceptedClientRequests(loggedUserId),
                  _getAcceptedCoachRequest(loggedUserId),
                  (
                    User? loggedUserData,
                    List<CoachingRequestShort> acceptedClientRequests,
                    CoachingRequestShort? acceptedCoachRequest,
                  ) =>
                      HomeCubitListenedParams(
                    loggedUserData: loggedUserData,
                    acceptedClientRequests: acceptedClientRequests,
                    acceptedCoachRequest: acceptedCoachRequest,
                  ),
                )
              : Stream.value(null),
        )
        .listen(
          (HomeCubitListenedParams? params) => emit(
            state.copyWith(
              status: params == null ? const BlocStatusNoLoggedUser() : null,
              accountType: params?.loggedUserData?.accountType,
              loggedUserName: params?.loggedUserData?.name,
              appSettings: params?.loggedUserData?.settings,
              acceptedClientRequests: params?.acceptedClientRequests,
              acceptedCoachRequest: params?.acceptedCoachRequest,
            ),
          ),
        );
  }

  Future<void> deleteCoachingRequest(String requestId) async {
    await _coachingRequestService.deleteCoachingRequest(requestId: requestId);
  }

  Future<void> signOut() async {
    emitLoadingStatus();
    await _authService.signOut();
    emitCompleteStatus(info: HomeCubitInfo.userSignedOut);
  }

  Stream<List<CoachingRequestShort>> _getAcceptedClientRequests(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.coachToClient,
          )
          .map((requests) => requests.where((req) => req.isAccepted))
          .doOnData(
            (acceptedReqs) => acceptedReqs.isNotEmpty
                ? _personRepository.refreshPersonsByCoachId(
                    coachId: loggedUserId,
                  )
                : null,
          )
          .map(
            (acceptedReqs) => acceptedReqs.map(_convertToCoachingRequestShort),
          )
          .switchMap(
            (streams) => streams.isEmpty
                ? Stream.value([])
                : Rx.combineLatest(
                    streams,
                    (acceptedClientRequests) => acceptedClientRequests,
                  ),
          );

  Stream<CoachingRequestShort?> _getAcceptedCoachRequest(
    String loggedUserId,
  ) =>
      _coachingRequestService
          .getCoachingRequestsBySenderId(
            senderId: loggedUserId,
            direction: CoachingRequestDirection.clientToCoach,
          )
          .map((requests) => requests.firstWhereOrNull((req) => req.isAccepted))
          .doOnData(
            (acceptedReq) => acceptedReq != null
                ? _userRepository.refreshUserById(userId: loggedUserId)
                : null,
          )
          .switchMap(
            (CoachingRequest? acceptedReq) => acceptedReq != null
                ? _convertToCoachingRequestShort(acceptedReq)
                : Stream.value(null),
          );

  Stream<CoachingRequestShort> _convertToCoachingRequestShort(
    CoachingRequest request,
  ) =>
      Rx.combineLatest2(
        Stream.value(request.id),
        _personRepository
            .getPersonById(personId: request.receiverId)
            .whereNotNull(),
        (reqId, receiver) => CoachingRequestShort(
          id: reqId,
          personToDisplay: receiver,
        ),
      );
}

enum HomeCubitInfo { userSignedOut }

class HomeCubitListenedParams extends Equatable {
  final User? loggedUserData;
  final List<CoachingRequestShort> acceptedClientRequests;
  final CoachingRequestShort? acceptedCoachRequest;

  const HomeCubitListenedParams({
    required this.loggedUserData,
    required this.acceptedClientRequests,
    required this.acceptedCoachRequest,
  });

  @override
  List<Object?> get props => [
        loggedUserData,
        acceptedClientRequests,
        acceptedCoachRequest,
      ];
}
