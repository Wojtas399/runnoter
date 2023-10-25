import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/reauthentication_status_mapper.dart';
import 'package:runnoter/data/service/auth/auth_service.dart';

void main() {
  test(
    'map reauthentication status from firebase, '
    'firebase reauthentication status confirmed should be mapped to domain reauthentication status confirmed',
    () {
      const firebaseStatus = firebase.ReauthenticationStatus.confirmed;
      const expectedStatus = ReauthenticationStatus.confirmed;

      final status = mapReauthenticationStatusFromFirebase(firebaseStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map reauthentication status from firebase, '
    'firebase reauthentication status cancelled should be mapped to domain reauthentication status cancelled',
    () {
      const firebaseStatus = firebase.ReauthenticationStatus.cancelled;
      const expectedStatus = ReauthenticationStatus.cancelled;

      final status = mapReauthenticationStatusFromFirebase(firebaseStatus);

      expect(status, expectedStatus);
    },
  );

  test(
    'map reauthentication status from firebase, '
    'firebase reauthentication status userMismatch should be mapped to domain reauthentication status userMismatch',
    () {
      const firebaseStatus = firebase.ReauthenticationStatus.userMismatch;
      const expectedStatus = ReauthenticationStatus.userMismatch;

      final status = mapReauthenticationStatusFromFirebase(firebaseStatus);

      expect(status, expectedStatus);
    },
  );
}
