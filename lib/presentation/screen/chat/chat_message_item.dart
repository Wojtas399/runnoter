import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../../domain/entity/message.dart';
import '../../../domain/entity/message_image.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../dialog/chat_image_preview/chat_image_preview_dialog.dart';
import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';
import 'chat_message_card.dart';

class ChatMessageItem extends StatelessWidget {
  final bool isNew;
  final double maxWidth;
  final ChatMessage message;

  const ChatMessageItem({
    super.key,
    required this.isNew,
    required this.maxWidth,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return message.text?.isNotEmpty == true || message.images.isNotEmpty
        ? Row(
            mainAxisAlignment: message.hasBeenSentByLoggedUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              _AnimatedBody(
                shouldRunAnimation: isNew,
                hasMessageBeenSentByLoggedUser: message.hasBeenSentByLoggedUser,
                child: ChatMessageCard(
                  hasMessageBeenSentByLoggedUser:
                      message.hasBeenSentByLoggedUser,
                  child: _MessageContent(maxWidth: maxWidth, message: message),
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class _AnimatedBody extends StatefulWidget {
  final bool shouldRunAnimation;
  final bool hasMessageBeenSentByLoggedUser;
  final Widget child;

  const _AnimatedBody({
    required this.shouldRunAnimation,
    required this.hasMessageBeenSentByLoggedUser,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _AnimatedBodyState();
}

class _AnimatedBodyState extends State<_AnimatedBody>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _animationController;
  late final Animation<double> _sizeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
    _scaleAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutQuart,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.shouldRunAnimation
        ? SizeTransition(
            sizeFactor: _sizeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              alignment: widget.hasMessageBeenSentByLoggedUser
                  ? Alignment.bottomRight
                  : Alignment.bottomLeft,
              child: widget.child,
            ),
          )
        : widget.child;
  }
}

class _MessageContent extends StatelessWidget {
  final double maxWidth;
  final ChatMessage message;

  const _MessageContent({required this.maxWidth, required this.message});

  @override
  Widget build(BuildContext context) {
    const double cardPadding = 12;
    final ThemeData theme = Theme.of(context);

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(cardPadding),
      child: Column(
        crossAxisAlignment: message.hasBeenSentByLoggedUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          if (message.images.isNotEmpty)
            _Images(
              images: message.images,
              doesTextExist: message.text != null,
              maxMessageWidth: maxWidth,
              cardPadding: cardPadding,
              isSender: message.hasBeenSentByLoggedUser,
            ),
          if (message.text?.isNotEmpty == true)
            BodyMedium(
              message.text!,
              color: message.hasBeenSentByLoggedUser ? theme.canvasColor : null,
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              LabelSmall(
                message.sendDateTime.toTime(),
                color: message.hasBeenSentByLoggedUser
                    ? theme.colorScheme.outlineVariant
                    : theme.colorScheme.outline,
              ),
              if (message.hasBeenSentByLoggedUser) ...[
                const GapHorizontal8(),
                _MessageStatusIcon(status: message.status),
              ],
            ],
          ),
        ].addSeparator(const Gap8()),
      ),
    );
  }
}

class _Images extends StatelessWidget {
  final List<MessageImage> images;
  final bool doesTextExist;
  final double maxMessageWidth;
  final double cardPadding;
  final bool isSender;

  const _Images({
    required this.images,
    required this.doesTextExist,
    required this.maxMessageWidth,
    required this.cardPadding,
    required this.isSender,
  });

  @override
  Widget build(BuildContext context) {
    final int numberOfImages = images.length;
    const int maxImagesInRow = 3;
    final int numberOfAllRows = (numberOfImages ~/ maxImagesInRow) + 1;
    final int numberOfImagesInLastRow = numberOfImages % maxImagesInRow;
    const Radius borderRadius = Radius.circular(8);

    return ClipRRect(
      clipBehavior: Clip.hardEdge,
      borderRadius: const BorderRadius.only(
        topLeft: borderRadius,
        topRight: borderRadius,
      ),
      child: Wrap(
        alignment: isSender ? WrapAlignment.end : WrapAlignment.start,
        children: images.asMap().entries.map(
          (MapEntry<int, MessageImage> entry) {
            final int currentRow = (entry.key ~/ maxImagesInRow) + 1;
            int imagesInRow = currentRow == numberOfAllRows
                ? numberOfImagesInLastRow
                : maxImagesInRow;
            double? width = (maxMessageWidth - 2 * cardPadding) / imagesInRow;
            double? height = kIsWeb ? 210 : 90;
            if (imagesInRow == 1) {
              width = images.length == 1 ? null : double.infinity;
              height = null;
            }

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _onTap(context, entry.value),
                child: Container(
                  width: width,
                  height: height,
                  constraints: const BoxConstraints(maxHeight: 400),
                  padding: EdgeInsets.only(
                    right: entry.key < imagesInRow - 1 ? 8 : 0,
                    bottom: currentRow != numberOfAllRows ? 8 : 0,
                  ),
                  child: Image.memory(
                    entry.value.bytes,
                    fit: BoxFit.cover,
                    frameBuilder: (context, child, frame, _) => frame == 0
                        ? child
                        : CircularProgressIndicator(
                            color: Theme.of(context).canvasColor,
                          ),
                  ),
                ),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  void _onTap(BuildContext context, MessageImage image) {
    showFullScreenDialog(
      ChatImagePreviewDialog(
        chatId: context.read<ChatCubit>().chatId,
        selectedImage: image,
      ),
    );
  }
}

class _MessageStatusIcon extends StatelessWidget {
  final MessageStatus status;

  const _MessageStatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    return Icon(
      switch (status) {
        MessageStatus.sent => MdiIcons.check,
        MessageStatus.read => MdiIcons.checkAll,
      },
      size: 16,
      color: switch (status) {
        MessageStatus.sent => Theme.of(context).colorScheme.outlineVariant,
        MessageStatus.read => Theme.of(context).colorScheme.primaryContainer,
      },
    );
  }
}
