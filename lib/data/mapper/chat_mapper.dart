import 'package:firebase/firebase.dart';

import '../../domain/entity/chat.dart';

Chat mapChatFromDto(ChatDto chatDto) => Chat(
      id: chatDto.id,
      user1Id: chatDto.user1Id,
      user2Id: chatDto.user2Id,
      isUser1Typing: false,
      isUser2Typing: false,
    );
//TODO: Implement mapping for users typing status
