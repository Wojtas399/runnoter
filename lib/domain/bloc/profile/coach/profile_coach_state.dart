part of 'profile_coach_bloc.dart';

class ProfileCoachState extends BlocState<ProfileCoachState> {
  final List<CoachingRequestDetails>? sentCoachingRequests;
  final List<CoachingRequestDetails>? receivedCoachingRequests;
  final Person? coach;

  const ProfileCoachState({
    required super.status,
    this.sentCoachingRequests,
    this.receivedCoachingRequests,
    this.coach,
  });

  @override
  List<Object?> get props => [
        status,
        sentCoachingRequests,
        receivedCoachingRequests,
        coach,
      ];

  @override
  ProfileCoachState copyWith({
    BlocStatus? status,
    List<CoachingRequestDetails>? sentCoachingRequests,
    List<CoachingRequestDetails>? receivedCoachingRequests,
    Person? coach,
  }) =>
      ProfileCoachState(
        status: status ?? const BlocStatusComplete(),
        sentCoachingRequests: sentCoachingRequests ?? this.sentCoachingRequests,
        receivedCoachingRequests:
            receivedCoachingRequests ?? this.receivedCoachingRequests,
        coach: coach ?? this.coach,
      );
}

class CoachingRequestDetails extends Equatable {
  final String id;
  final Person personToDisplay;

  const CoachingRequestDetails({
    required this.id,
    required this.personToDisplay,
  });

  @override
  List<Object?> get props => [id, personToDisplay];
}
