import 'package:firebase/firebase.dart';

import '../../domain/entity/message.dart';

Message mapMessageFromDto(MessageDto messageDto) => Message(
      id: messageDto.id,
      status: MessageStatus.sent, //TODO: Implement message status mapping
      chatId: messageDto.chatId,
      senderId: messageDto.senderId,
      dateTime: messageDto.dateTime,
      text: messageDto.text,
    );
