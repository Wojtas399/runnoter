import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/nullable_text_component.dart';
import '../../extension/context_extensions.dart';
import '../../feature/common/chat_gallery/chat_gallery.dart';
import 'chat_adjustable_list_of_messages.dart';
import 'chat_bottom_part.dart';
import 'chat_typing_indicator.dart';

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
        actions: const [
          _ChatGalleryIcon(),
          kIsWeb ? GapHorizontal16() : GapHorizontal8(),
        ],
      ),
      endDrawer: Drawer(
        width: context.isMobileSize ? double.infinity : 600,
        child: ChatGallery(chatId: context.read<ChatCubit>().chatId),
      ),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: BigBody(
                child: Column(
                  children: [
                    const Expanded(
                      child: ChatAdjustableListOfMessages(),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: _TypingIndicator(),
                    ),
                    ChatBottomPart(),
                  ],
                ),
              ),
            ),
          ],
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

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    final bool isRecipientTyping = context.select(
      (ChatCubit cubit) => cubit.state.isRecipientTyping,
    );

    return ChatTypingIndicator(showIndicator: isRecipientTyping);
  }
}

class _ChatGalleryIcon extends StatelessWidget {
  const _ChatGalleryIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: Scaffold.of(context).openEndDrawer,
      icon: const Icon(Icons.photo_library),
    );
  }
}
