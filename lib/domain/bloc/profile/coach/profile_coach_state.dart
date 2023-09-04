part of 'profile_coach_bloc.dart';

class ProfileCoachState extends BlocState<ProfileCoachState> {
  final List<CoachingRequestShort>? sentRequests;
  final List<CoachingRequestShort>? receivedRequests;
  final Person? coach;
  final String? idOfChatWithCoach;

  const ProfileCoachState({
    required super.status,
    this.sentRequests,
    this.receivedRequests,
    this.coach,
    this.idOfChatWithCoach,
  });

  @override
  List<Object?> get props => [
        status,
        sentRequests,
        receivedRequests,
        coach,
        idOfChatWithCoach,
      ];

  @override
  ProfileCoachState copyWith({
    BlocStatus? status,
    List<CoachingRequestShort>? sentRequests,
    List<CoachingRequestShort>? receivedRequests,
    Person? coach,
    bool setCoachAsNull = false,
    String? idOfChatWithCoach,
  }) =>
      ProfileCoachState(
        status: status ?? const BlocStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        receivedRequests: receivedRequests ?? this.receivedRequests,
        coach: setCoachAsNull ? null : coach ?? this.coach,
        idOfChatWithCoach: idOfChatWithCoach ?? this.idOfChatWithCoach,
      );
}
