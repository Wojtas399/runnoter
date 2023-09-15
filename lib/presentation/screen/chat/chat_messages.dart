import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../../domain/entity/message.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../component/text/label_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../formatter/date_formatter.dart';
import 'chat_message_item.dart';

class ChatMessages extends StatelessWidget {
  final DateService _dateService = getIt<DateService>();
  final ScrollController? scrollController;

  ChatMessages({super.key, this.scrollController});

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

                  return ListView.separated(
                    reverse: true,
                    padding: const EdgeInsets.all(16),
                    itemCount: messages.length + 1,
                    controller: scrollController,
                    separatorBuilder: (_, int itemIndex) {
                      if (itemIndex >= messages.length - 1) {
                        return const SizedBox();
                      }
                      final Message currentMessage = messages[itemIndex];
                      final Message nextMessage = messages[itemIndex + 1];
                      final bool areDifferentDays =
                          !_dateService.areDaysTheSame(
                        currentMessage.dateTime,
                        nextMessage.dateTime,
                      );
                      return areDifferentDays
                          ? _DaySeparator(date: currentMessage.dateTime)
                          : const SizedBox();
                    },
                    itemBuilder: (_, int messageIndex) {
                      if (messageIndex == messages.length) {
                        final Message previousMessage =
                            messages[messageIndex - 1];
                        return _DaySeparator(date: previousMessage.dateTime);
                      }
                      final Message currentMessage = messages[messageIndex];
                      return ChatMessageItem(
                        maxWidth: maxMessageWidth,
                        isSender: loggedUserId == currentMessage.senderId,
                        text: currentMessage.text,
                        images: const [], //TODO
                        dateTime: currentMessage.dateTime,
                      );
                    },
                  );
                },
              ),
          };
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
