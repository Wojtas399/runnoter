part of 'profile_coach_cubit.dart';

class ProfileCoachState extends CubitState<ProfileCoachState> {
  final List<CoachingRequestShort>? sentRequests;
  final List<CoachingRequestShort>? receivedRequests;
  final Person? coach;
  final String? coachId;
  final String? coachFullName;
  final String? coachEmail;
  final String? idOfChatWithCoach;

  const ProfileCoachState({
    required super.status,
    this.sentRequests,
    this.receivedRequests,
    this.coach,
    this.coachId,
    this.coachFullName,
    this.coachEmail,
    this.idOfChatWithCoach,
  });

  @override
  List<Object?> get props => [
        status,
        sentRequests,
        receivedRequests,
        coach,
        coachId,
        coachFullName,
        coachEmail,
        idOfChatWithCoach,
      ];

  bool get doesCoachExist =>
      coachId != null && coachFullName != null && coachEmail != null;

  @override
  ProfileCoachState copyWith({
    BlocStatus? status,
    List<CoachingRequestShort>? sentRequests,
    List<CoachingRequestShort>? receivedRequests,
    Person? coach,
    String? coachId,
    String? coachFullName,
    String? coachEmail,
    bool deletedCoachParams = false,
    String? idOfChatWithCoach,
  }) =>
      ProfileCoachState(
        status: status ?? const BlocStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        receivedRequests: receivedRequests ?? this.receivedRequests,
        coach: deletedCoachParams ? null : coach ?? this.coach,
        coachId: deletedCoachParams ? null : coachId ?? this.coachId,
        coachFullName:
            deletedCoachParams ? null : coachFullName ?? this.coachFullName,
        coachEmail: deletedCoachParams ? null : coachEmail ?? this.coachEmail,
        idOfChatWithCoach: idOfChatWithCoach ?? this.idOfChatWithCoach,
      );
}
