import 'package:firebase/firebase.dart';

import '../../domain/entity/message.dart';

Message mapMessageFromDto(MessageDto messageDto) => Message(
      id: messageDto.id,
      chatId: messageDto.chatId,
      senderId: messageDto.senderId,
      content: messageDto.content,
      dateTime: messageDto.dateTime,
    );
