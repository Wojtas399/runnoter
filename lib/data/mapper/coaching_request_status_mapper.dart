import 'package:firebase/firebase.dart' as firebase;

import '../../domain/additional_model/coaching_request.dart';

CoachingRequestStatus mapCoachingRequestStatusFromDto(
  firebase.CoachingRequestStatus dtoCoachingRequestStatus,
) =>
    switch (dtoCoachingRequestStatus) {
      firebase.CoachingRequestStatus.pending => CoachingRequestStatus.pending,
      firebase.CoachingRequestStatus.accepted => CoachingRequestStatus.accepted,
      firebase.CoachingRequestStatus.declined => CoachingRequestStatus.declined,
    };

firebase.CoachingRequestStatus mapCoachingRequestStatusToDto(
  CoachingRequestStatus coachingRequestStatus,
) =>
    switch (coachingRequestStatus) {
      CoachingRequestStatus.pending => firebase.CoachingRequestStatus.pending,
      CoachingRequestStatus.accepted => firebase.CoachingRequestStatus.accepted,
      CoachingRequestStatus.declined => firebase.CoachingRequestStatus.declined,
    };
