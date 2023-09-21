import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/message_status_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map message status from str, '
    'sent string should be mapped to MessageStatus.sent type',
    () {
      const String statusStr = 'sent';
      const MessageStatus expectedStatus = MessageStatus.sent;

      final MessageStatus status = mapMessageStatusFromStr(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map message status from str, '
    'read string should be mapped to MessageStatus.read type',
    () {
      const String statusStr = 'read';
      const MessageStatus expectedStatus = MessageStatus.read;

      final MessageStatus status = mapMessageStatusFromStr(statusStr);

      expect(status, expectedStatus);
    },
  );

  test(
    'map message status to str, '
    'MessageStatus.sent type should be mapped to sent string',
    () {
      const MessageStatus status = MessageStatus.sent;
      const String expectedStatusStr = 'sent';

      final String statusStr = mapMessageStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );

  test(
    'map message status to str, '
    'MessageStatus.read type should be mapped to read string',
    () {
      const MessageStatus status = MessageStatus.read;
      const String expectedStatusStr = 'read';

      final String statusStr = mapMessageStatusToString(status);

      expect(statusStr, expectedStatusStr);
    },
  );
}
