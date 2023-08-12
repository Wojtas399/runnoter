part of 'profile_coach_bloc.dart';

class ProfileCoachState extends BlocState<ProfileCoachState> {
  final List<CoachingRequestInfo>? receivedCoachingRequests;
  final Person? coach;

  const ProfileCoachState({
    required super.status,
    this.receivedCoachingRequests,
    this.coach,
  });

  @override
  List<Object?> get props => [status, receivedCoachingRequests, coach];

  @override
  ProfileCoachState copyWith({
    BlocStatus? status,
    List<CoachingRequestInfo>? receivedCoachingRequests,
    Person? coach,
  }) =>
      ProfileCoachState(
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
