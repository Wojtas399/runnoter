part of 'coach_bloc.dart';

class CoachState extends BlocState<CoachState> {
  final List<CoachingRequestInfo>? receivedCoachingRequests;
  final Person? coach;

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
    Person? coach,
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
  final Person sender;

  const CoachingRequestInfo({
    required this.id,
    required this.sender,
  });

  @override
  List<Object?> get props => [id, sender];
}
