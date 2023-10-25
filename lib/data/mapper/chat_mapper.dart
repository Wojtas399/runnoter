import 'package:firebase/firebase.dart';

import '../model/chat.dart';

Chat mapChatFromDto(ChatDto chatDto) => Chat(
      id: chatDto.id,
      user1Id: chatDto.user1Id,
      user2Id: chatDto.user2Id,
      user1LastTypingDateTime: chatDto.user1LastTypingDateTime,
      user2LastTypingDateTime: chatDto.user2LastTypingDateTime,
    );
