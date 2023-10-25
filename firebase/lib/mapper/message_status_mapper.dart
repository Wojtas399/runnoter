import '../firebase.dart';

MessageStatus mapMessageStatusFromStr(String str) =>
    MessageStatus.values.byName(str);

String mapMessageStatusToString(MessageStatus status) => status.name;
