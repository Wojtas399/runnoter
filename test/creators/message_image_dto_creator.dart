import 'package:firebase/firebase.dart';

MessageImageDto createMessageImageDto({
  String id = '',
  String messageId = '',
  DateTime? sendDateTime,
  int order = 1,
}) =>
    MessageImageDto(
      id: id,
      messageId: messageId,
      sendDateTime: sendDateTime ?? DateTime(2023),
      order: order,
    );
