import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'cubit/chat_cubit.dart';
import '../../../../domain/cubit/internet_connection_cubit.dart';
import '../../../component/body/big_body_component.dart';
import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/nullable_text_component.dart';
import '../../../component/text/body_text_components.dart';
import '../../../extension/context_extensions.dart';
import '../../../feature/common/chat_gallery/chat_gallery.dart';
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
      body: const SafeArea(
        child: Column(
          children: [
            _InternetConnectionStatus(),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: BigBody(
                      child: Column(
                        children: [
                          Expanded(
                            child: ChatAdjustableListOfMessages(),
                          ),
                          _TypingIndicator(),
                          ChatBottomPart(),
                        ],
                      ),
                    ),
                  ),
                ],
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

class _InternetConnectionStatus extends StatefulWidget {
  const _InternetConnectionStatus();

  @override
  State<StatefulWidget> createState() => _InternetConnectionStatusState();
}

class _InternetConnectionStatusState extends State<_InternetConnectionStatus>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _sizeAnimation;
  StreamSubscription<bool?>? _internetConnectionListener;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _internetConnectionListener =
        context.read<InternetConnectionCubit>().stream.listen(
      (bool? isInternetConnection) {
        if (isInternetConnection == false) {
          _animController.forward();
        } else if (isInternetConnection == true) {
          _animController.reverse();
        }
      },
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    _internetConnectionListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: _sizeAnimation,
      child: Container(
        width: double.infinity,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BodyMedium(
              Str.of(context).noInternetConnectionDialogTitle,
              color: Theme.of(context).canvasColor,
            ),
          ],
        ),
      ),
    );
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
