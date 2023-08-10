part of 'coach_bloc.dart';

class CoachState extends BlocState<CoachState> {
  final List<CoachingRequest>? receivedCoachingRequests;
  final UserBasicInfo? coach;

  const CoachState({
    required super.status,
    this.receivedCoachingRequests,
    this.coach,
  });

  @override
  CoachState copyWith({
    BlocStatus? status,
    List<CoachingRequest>? receivedCoachingRequests,
    UserBasicInfo? coach,
  }) =>
      CoachState(
        status: status ?? const BlocStatusComplete(),
        receivedCoachingRequests:
            receivedCoachingRequests ?? this.receivedCoachingRequests,
        coach: coach ?? this.coach,
      );
}
