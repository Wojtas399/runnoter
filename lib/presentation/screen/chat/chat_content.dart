import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../../domain/entity/message.dart';
import '../../component/body/big_body_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/nullable_text_component.dart';
import 'chat_bottom_part.dart';
import 'chat_message_item.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const _RecipientFullName(),
      ),
      body: SafeArea(
        child: BigBody(
          child: RefreshIndicator(
            onRefresh: () async =>
                await context.read<ChatCubit>().loadOlderMessages(),
            child: Column(
              children: [
                const Expanded(
                  child: _Messages(),
                ),
                ChatBottomPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipientFullName extends StatelessWidget {
  const _RecipientFullName();

  @override
  Widget build(BuildContext context) {
    final String? recipientFullName = context.select(
      (ChatCubit cubit) => cubit.state.recipientFullName,
    );

    return NullableText(recipientFullName);
  }
}

class _Messages extends StatelessWidget {
  const _Messages();

  @override
  Widget build(BuildContext context) {
    final String? loggedUserId = context.select(
      (ChatCubit cubit) => cubit.state.loggedUserId,
    );
    final List<Message>? messages = context.select(
      (ChatCubit cubit) => cubit.state.messagesFromLatest,
    );

    return messages == null || loggedUserId == null
        ? const LoadingInfo()
        : ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final Message message = messages[index];

              return ChatMessageItem(
                isSender: loggedUserId == message.senderId,
                text: message.text,
                images: message.images,
                dateTime: message.dateTime,
              );
            },
          );
  }
}
