import 'package:firebase/firebase.dart';

import '../entity/message.dart';
import 'message_status_mapper.dart';

Message mapMessageFromDto(MessageDto messageDto) => Message(
      id: messageDto.id,
      status: mapMessageStatusFromDto(messageDto.status),
      chatId: messageDto.chatId,
      senderId: messageDto.senderId,
      dateTime: messageDto.dateTime,
      text: messageDto.text,
    );
