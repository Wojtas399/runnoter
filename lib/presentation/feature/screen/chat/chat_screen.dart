import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/cubit/chat/chat_cubit.dart';
import '../../../component/cubit_with_status_listener_component.dart';
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
            child: const CubitWithStatusListener<ChatCubit, ChatState, dynamic,
                dynamic>(
              showDialogOnLoading: false,
              child: ChatContent(),
            ),
          )
        : const PageNotFound();
  }
}