part of 'coach_bloc.dart';

class CoachState extends BlocState<CoachState> {
  final List<Invitation>? invitations;
  final UserBasicInfo? coach;

  const CoachState({
    required super.status,
    this.invitations,
    this.coach,
  });

  @override
  CoachState copyWith({
    BlocStatus? status,
    List<Invitation>? invitations,
    UserBasicInfo? coach,
  }) =>
      CoachState(
        status: status ?? const BlocStatusComplete(),
        invitations: invitations ?? this.invitations,
        coach: coach ?? this.coach,
      );
}
