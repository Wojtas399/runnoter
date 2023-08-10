import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/user_basic_info.dart';

class CoachState extends BlocState<CoachState> {
  final CoachStatus? coachStatus;
  final UserBasicInfo? coach;

  const CoachState({
    required super.status,
    this.coachStatus,
    this.coach,
  });

  @override
  CoachState copyWith({
    BlocStatus? status,
    CoachStatus? coachStatus,
    UserBasicInfo? coach,
  }) =>
      CoachState(
        status: status ?? const BlocStatusComplete(),
        coachStatus: coachStatus ?? this.coachStatus,
        coach: coach ?? this.coach,
      );
}

enum CoachStatus { notFound, waitingForApproval, accepted }
