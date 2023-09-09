import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/cubit_status.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/page_not_found_component.dart';
import '../../service/dialog_service.dart';
import 'chat_content.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  final String? chatId;

  const ChatScreen({super.key, @PathParam('chatId') this.chatId});

  @override
  Widget build(BuildContext context) {
    return chatId != null
        ? BlocProvider(
            create: (_) => ChatCubit(chatId: chatId!)..initialize(),
            child: const _CubitListener(
              child: ChatContent(),
            ),
          )
        : const PageNotFound();
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        final CubitStatus cubitStatus = state.status;
        if (cubitStatus is CubitStatusError) {
          _manageError(context, cubitStatus.error);
        }
      },
      child: child,
    );
  }

  Future<void> _manageError(BuildContext context, ChatCubitError error) async {
    switch (error) {
      case ChatCubitError.noInternetConnection:
        await showNoInternetConnectionMessage();
        break;
    }
  }
}
