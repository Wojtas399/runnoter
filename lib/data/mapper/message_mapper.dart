import 'package:firebase/firebase.dart';

import '../../domain/entity/message.dart';

Message mapMessageFromDto(MessageDto messageDto) => Message(
      id: messageDto.id,
      chatId: messageDto.chatId,
      senderId: messageDto.senderId,
      dateTime: messageDto.dateTime,
      text: messageDto.text,
    );
