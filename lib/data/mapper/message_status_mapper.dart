import 'package:firebase/firebase.dart' as firebase;

import '../../domain/entity/message.dart';

MessageStatus mapMessageStatusFromDto(
  firebase.MessageStatus dtoMessageStatus,
) =>
    switch (dtoMessageStatus) {
      firebase.MessageStatus.sent => MessageStatus.sent,
      firebase.MessageStatus.read => MessageStatus.read,
    };

firebase.MessageStatus mapMessageStatusToDto(MessageStatus messageStatus) =>
    switch (messageStatus) {
      MessageStatus.sent => firebase.MessageStatus.sent,
      MessageStatus.read => firebase.MessageStatus.read,
    };
