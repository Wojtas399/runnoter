import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/label_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import 'chat_message_item.dart';

class ChatMessages extends StatelessWidget {
  final ScrollController? scrollController;

  const ChatMessages({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    final String? loggedUserId = context.select(
      (ChatCubit cubit) => cubit.state.loggedUserId,
    );
    final List<ChatMessage>? messages = context.select(
      (ChatCubit cubit) => cubit.state.messagesFromLatest,
    );

    return messages == null || loggedUserId == null
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
                    scrollController: scrollController,
                    maxMessageWidth: maxMessageWidth,
                  );
                },
              ),
          };
  }
}

class _MessagesList extends StatelessWidget {
  final ScrollController? scrollController;
  final double maxMessageWidth;
  final DateService _dateService = getIt<DateService>();

  _MessagesList({this.scrollController, required this.maxMessageWidth});

  @override
  Widget build(BuildContext context) {
    final String loggedUserId = context.select(
      (ChatCubit cubit) => cubit.state.loggedUserId!,
    );
    final List<ChatMessage> messages = context.select(
      (ChatCubit cubit) => cubit.state.messagesFromLatest!,
    );
    final List<Widget> elements =
        _createMessagesWithSeparators(messages, loggedUserId);

    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      child: ListView.builder(
        reverse: true,
        padding: const EdgeInsets.all(16),
        controller: scrollController,
        itemCount: elements.length,
        itemBuilder: (_, int elementIndex) => elements[elementIndex],
      ),
    );
  }

  List<Widget> _createMessagesWithSeparators(
    List<ChatMessage> messages,
    String loggedUserId,
  ) {
    final List<Widget> elements = [];
    for (int elementIdx = 0; elementIdx < messages.length + 1; elementIdx++) {
      if (elementIdx == messages.length) {
        final previousMsg = messages[elementIdx - 1];
        elements.add(_DaySeparator(date: previousMsg.sendDateTime));
        continue;
      }
      final ChatMessage currentMsg = messages[elementIdx];
      final ChatMessageItem chatMessageItem = ChatMessageItem(
        maxWidth: maxMessageWidth,
        isSender: loggedUserId == currentMsg.senderId,
        text: currentMsg.text,
        images: currentMsg.images,
        dateTime: currentMsg.sendDateTime,
      );
      if (elementIdx < messages.length - 1) {
        final ChatMessage nextMsg = messages[elementIdx + 1];
        final bool areDifferentDays = !_dateService.areDaysTheSame(
          currentMsg.sendDateTime,
          nextMsg.sendDateTime,
        );
        if (areDifferentDays) {
          elements.addAll([
            chatMessageItem,
            _DaySeparator(date: currentMsg.sendDateTime),
          ]);
          continue;
        }
      }
      elements.add(chatMessageItem);
    }
    return elements;
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
