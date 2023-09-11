import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../../domain/entity/message.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/body_text_components.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

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
              return _Message(
                isSender: loggedUserId == message.senderId,
                message:
                    '', //TODO: Add message item which contains text and images
              );
            },
          );
  }
}

class _Message extends StatelessWidget {
  final bool isSender;
  final String message;

  const _Message({required this.isSender, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Card(
          color: isSender ? Theme.of(context).colorScheme.primary : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BodyMedium(
              message,
              color: isSender ? Theme.of(context).canvasColor : null,
            ),
          ),
        ),
      ],
    );
  }
}
