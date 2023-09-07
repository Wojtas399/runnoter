import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/nullable_text_component.dart';
import 'chat_bottom_part.dart';
import 'chat_messages.dart';

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
                  child: ChatMessages(),
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
