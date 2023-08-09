import 'package:firebase/firebase.dart' as firebase;

import '../../domain/additional_model/invitation.dart';

InvitationStatus mapInvitationStatusFromDto(
  firebase.InvitationStatus dtoInvitationStatus,
) =>
    switch (dtoInvitationStatus) {
      firebase.InvitationStatus.pending => InvitationStatus.pending,
      firebase.InvitationStatus.accepted => InvitationStatus.accepted,
      firebase.InvitationStatus.discarded => InvitationStatus.discarded,
    };

firebase.InvitationStatus mapInvitationStatusToDto(
  InvitationStatus invitationStatus,
) =>
    switch (invitationStatus) {
      InvitationStatus.pending => firebase.InvitationStatus.pending,
      InvitationStatus.accepted => firebase.InvitationStatus.accepted,
      InvitationStatus.discarded => firebase.InvitationStatus.discarded,
    };
