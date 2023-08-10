import 'package:firebase/firebase.dart' as firebase;

import '../../domain/additional_model/coaching_request.dart';

CoachingRequestStatus mapCoachingRequestStatusFromDto(
  firebase.InvitationStatus dtoInvitationStatus,
) =>
    switch (dtoInvitationStatus) {
      firebase.InvitationStatus.pending => CoachingRequestStatus.pending,
      firebase.InvitationStatus.accepted => CoachingRequestStatus.accepted,
      firebase.InvitationStatus.discarded => CoachingRequestStatus.declined,
    };

firebase.InvitationStatus mapCoachingRequestStatusToDto(
  CoachingRequestStatus coachingRequestStatus,
) =>
    switch (coachingRequestStatus) {
      CoachingRequestStatus.pending => firebase.InvitationStatus.pending,
      CoachingRequestStatus.accepted => firebase.InvitationStatus.accepted,
      CoachingRequestStatus.declined => firebase.InvitationStatus.discarded,
    };
