import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../common_feature/chat_gallery/chat_gallery.dart';
import '../../component/body/big_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/nullable_text_component.dart';
import '../../extension/context_extensions.dart';
import 'chat_adjustable_list_of_messages.dart';
import 'chat_bottom_part.dart';

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
