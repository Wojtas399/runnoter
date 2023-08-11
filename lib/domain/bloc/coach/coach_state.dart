part of 'coach_bloc.dart';

class CoachState extends BlocState<CoachState> {
  final List<CoachingRequestInfo>? receivedCoachingRequests;
  final UserBasicInfo? coach;

  const CoachState({
    required super.status,
    this.receivedCoachingRequests,
    this.coach,
  });

  @override
  List<Object?> get props => [status, receivedCoachingRequests, coach];

  @override
  CoachState copyWith({
    BlocStatus? status,
    List<CoachingRequestInfo>? receivedCoachingRequests,
    UserBasicInfo? coach,
  }) =>
      CoachState(
        status: status ?? const BlocStatusComplete(),
        receivedCoachingRequests:
            receivedCoachingRequests ?? this.receivedCoachingRequests,
        coach: coach ?? this.coach,
      );
}

class CoachingRequestInfo extends Equatable {
  final String id;
  final UserBasicInfo senderInfo;

  const CoachingRequestInfo({
    required this.id,
    required this.senderInfo,
  });

  @override
  List<Object?> get props => [id, senderInfo];
}
