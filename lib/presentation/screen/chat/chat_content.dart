import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../../domain/entity/message.dart';
import '../../component/body/big_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/nullable_text_component.dart';
import '../../component/text/label_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
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
                Expanded(
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
  final DateService _dateService = getIt<DateService>();

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
        : ListView.separated(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: messages.length + 1,
            separatorBuilder: (_, int itemIndex) {
              if (itemIndex >= messages.length - 1) return const SizedBox();
              final Message currentMessage = messages[itemIndex];
              final Message nextMessage = messages[itemIndex + 1];
              final bool areDifferentDays = !_dateService.areDaysTheSame(
                currentMessage.dateTime,
                nextMessage.dateTime,
              );
              return areDifferentDays
                  ? _DaySeparator(date: currentMessage.dateTime)
                  : const SizedBox();
            },
            itemBuilder: (_, int messageIndex) {
              if (messageIndex == messages.length) {
                final Message previousMessage = messages[messageIndex - 1];
                return _DaySeparator(date: previousMessage.dateTime);
              }
              final Message currentMessage = messages[messageIndex];
              return ChatMessageItem(
                isSender: loggedUserId == currentMessage.senderId,
                text: currentMessage.text,
                images: currentMessage.images,
                dateTime: currentMessage.dateTime,
              );
            },
          );
  }
}

class _DaySeparator extends StatelessWidget {
  final DateTime date;

  const _DaySeparator({required this.date});

  @override
  Widget build(BuildContext context) {
    const Widget divider = Expanded(
      child: Divider(height: 80),
    );
    const Widget gap = GapHorizontal16();

    return Row(
      children: [
        divider,
        gap,
        LabelLarge(date.toFullDate(context.languageCode)),
        gap,
        divider,
      ],
    );
  }
}
