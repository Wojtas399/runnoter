import 'package:firebase/firebase.dart' as firebase;

import '../../domain/service/auth_service.dart';

ReauthenticationStatus mapReauthenticationStatusFromFirebase(
  firebase.ReauthenticationStatus firebaseReauthenticationStatus,
) =>
    switch (firebaseReauthenticationStatus) {
      firebase.ReauthenticationStatus.confirmed =>
        ReauthenticationStatus.confirmed,
      firebase.ReauthenticationStatus.cancelled =>
        ReauthenticationStatus.cancelled,
      firebase.ReauthenticationStatus.userMismatch =>
        ReauthenticationStatus.userMismatch,
    };
