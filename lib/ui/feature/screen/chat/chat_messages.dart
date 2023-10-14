import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../common/date_service.dart';
import '../../../../dependency_injection.dart';
import 'cubit/chat_cubit.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../component/text/label_text_components.dart';
import '../../../extension/context_extensions.dart';
import '../../../formatter/date_formatter.dart';
import 'chat_message_item.dart';

class ChatMessages extends StatelessWidget {
  final ScrollController? scrollController;

  const ChatMessages({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage>? messages = context.select(
      (ChatCubit cubit) => cubit.state.messagesFromLatest,
    );

    return messages == null
        ? const LoadingInfo()
        : switch (messages) {
            [] => Paddings24(
                child: EmptyContentInfo(
                  icon: Icons.message,
                  title: Str.of(context).chatNoMessagesInfoTitle,
                  subtitle: Str.of(context).chatNoMessagesInfoMessage,
                ),
              ),
            [...] => LayoutBuilder(
                builder: (context, constraints) {
                  final double maxMessageWidth = constraints.maxWidth * 0.6;

                  return _MessagesList(
                    messages: messages,
                    scrollController: scrollController,
                    maxMessageWidth: maxMessageWidth,
                  );
                },
              ),
          };
  }
}

class _MessagesList extends StatefulWidget {
  final List<ChatMessage> messages;
  final ScrollController? scrollController;
  final double maxMessageWidth;

  const _MessagesList({
    required this.messages,
    this.scrollController,
    required this.maxMessageWidth,
  });

  @override
  State<StatefulWidget> createState() => _MessagesListState();
}

class _MessagesListState extends State<_MessagesList> {
  List<ChatMessage> _oldMessages = const [];
  final DateService _dateService = getIt<DateService>();

  bool get _isFirstMessageNew => _oldMessages.isNotEmpty
      ? _oldMessages.first != widget.messages[0]
      : false;

  @override
  void didUpdateWidget(covariant _MessagesList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _oldMessages = oldWidget.messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<ChatMessage> messages = widget.messages;
    final int numberOfMessages = messages.length;

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.separated(
        reverse: true,
        padding: const EdgeInsets.all(16),
        controller: widget.scrollController,
        itemCount: numberOfMessages + 1,
        separatorBuilder: (_, int separatorIndex) {
          if (separatorIndex >= numberOfMessages - 1) return const SizedBox();
          final currentMsg = messages[separatorIndex];
          final ChatMessage nextMsg = messages[separatorIndex + 1];
          final bool areDifferentDays = !_dateService.areDaysTheSame(
            currentMsg.dateTime,
            nextMsg.dateTime,
          );
          return areDifferentDays
              ? _DaySeparator(date: currentMsg.dateTime)
              : const SizedBox();
        },
        itemBuilder: (_, int messageIndex) {
          if (messageIndex == numberOfMessages) {
            final previousMsg = messages[messageIndex - 1];
            return _DaySeparator(date: previousMsg.dateTime);
          }
          final currentMsg = messages[messageIndex];
          return ChatMessageItem(
            key: ValueKey(currentMsg.id),
            isNew: messageIndex == 0 && _isFirstMessageNew,
            maxWidth: widget.maxMessageWidth,
            message: currentMsg,
          );
        },
      ),
    );
  }
}

class _DaySeparator extends StatelessWidget {
  final DateService _dateService = getIt<DateService>();
  final DateTime date;

  _DaySeparator({required this.date});

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
        LabelLarge(_createLabel(context)),
        gap,
        divider,
      ],
    );
  }

  String _createLabel(BuildContext context) {
    if (_dateService.isToday(date)) {
      return Str.of(context).today;
    }
    if (_dateService.areDaysTheSame(date, _dateService.getYesterday())) {
      return Str.of(context).yesterday;
    }
    return date.toFullDate(context.languageCode);
  }
}
