import 'package:firebase/firebase.dart';

import '../../domain/entity/chat.dart';

Chat mapChatFromDto({required ChatDto chatDto}) => Chat(
      id: chatDto.id,
      user1Id: chatDto.user1Id,
      user2Id: chatDto.user2Id,
    );
