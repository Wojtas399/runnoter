part of 'profile_coach_cubit.dart';

class ProfileCoachState extends CubitState<ProfileCoachState> {
  final List<CoachingRequestShort>? sentRequests;
  final List<CoachingRequestShort>? receivedRequests;
  final String? coachId;
  final String? coachFullName;
  final String? coachEmail;

  const ProfileCoachState({
    required super.status,
    this.sentRequests,
    this.receivedRequests,
    this.coachId,
    this.coachFullName,
    this.coachEmail,
  });

  @override
  List<Object?> get props => [
        status,
        sentRequests,
        receivedRequests,
        coachId,
        coachFullName,
        coachEmail,
      ];

  bool get doesCoachExist =>
      coachId != null && coachFullName != null && coachEmail != null;

  @override
  ProfileCoachState copyWith({
    CubitStatus? status,
    List<CoachingRequestShort>? sentRequests,
    List<CoachingRequestShort>? receivedRequests,
    String? coachId,
    String? coachFullName,
    String? coachEmail,
    bool deletedCoachParams = false,
  }) =>
      ProfileCoachState(
        status: status ?? const CubitStatusComplete(),
        sentRequests: sentRequests ?? this.sentRequests,
        receivedRequests: receivedRequests ?? this.receivedRequests,
        coachId: deletedCoachParams ? null : coachId ?? this.coachId,
        coachFullName:
            deletedCoachParams ? null : coachFullName ?? this.coachFullName,
        coachEmail: deletedCoachParams ? null : coachEmail ?? this.coachEmail,
      );
}
