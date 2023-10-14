import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/chat_cubit.dart';
import '../../../component/page_not_found_component.dart';
import 'chat_content.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  final String? chatId;

  const ChatScreen({super.key, @PathParam('chatId') this.chatId});

  @override
  Widget build(BuildContext context) {
    return chatId != null
        ? BlocProvider(
            create: (_) => ChatCubit(chatId: chatId!)
              ..initializeChatListener()
              ..initializeMessagesListener(),
            child: const ChatContent(),
          )
        : const PageNotFound();
  }
}
