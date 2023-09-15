import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../../domain/entity/message.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../dialog/chat_image_preview/chat_image_preview_dialog.dart';
import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';
import '../../service/dialog_service.dart';

class ChatMessageItem extends StatelessWidget {
  final double maxWidth;
  final bool isSender;
  final String? text;
  final List<MessageImage> images;
  final DateTime dateTime;

  const ChatMessageItem({
    super.key,
    required this.maxWidth,
    required this.isSender,
    required this.text,
    required this.images,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    const Radius borderRadius = Radius.circular(16);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return text?.isNotEmpty == true || images.isNotEmpty
        ? Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: borderRadius,
                    topRight: borderRadius,
                    bottomLeft: isSender ? borderRadius : Radius.zero,
                    bottomRight: isSender ? Radius.zero : borderRadius,
                  ),
                ),
                color:
                    isSender ? colorScheme.primary : colorScheme.surfaceVariant,
                child: _MessageContent(
                  maxWidth: maxWidth,
                  isSender: isSender,
                  text: text,
                  images: images,
                  dateTime: dateTime,
                ),
              ),
            ],
          )
        : const SizedBox();
  }
}

class _MessageContent extends StatelessWidget {
  final double maxWidth;
  final bool isSender;
  final String? text;
  final List<MessageImage> images;
  final DateTime dateTime;

  const _MessageContent({
    required this.maxWidth,
    required this.isSender,
    required this.text,
    required this.images,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    const double cardPadding = 12;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: const EdgeInsets.all(cardPadding),
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (images.isNotEmpty)
              _Images(
                images: images,
                doesTextExist: text != null,
                maxMessageWidth: maxWidth,
                cardPadding: cardPadding,
                isSender: isSender,
              ),
            if (text?.isNotEmpty == true)
              BodyMedium(
                text!,
                color: isSender ? Theme.of(context).canvasColor : null,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LabelSmall(
                  dateTime.toTime(),
                  color: isSender
                      ? Theme.of(context).colorScheme.outlineVariant
                      : Theme.of(context).colorScheme.outline,
                ),
              ],
            ),
          ].addSeparator(const Gap8()),
        ),
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

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        borderRadius:
            BorderRadius.only(topLeft: borderRadius, topRight: borderRadius),
      ),
      child: Wrap(
        alignment: isSender ? WrapAlignment.end : WrapAlignment.start,
        children: List.generate(
          numberOfImages,
          (int imageIndex) {
            final MessageImage image = images.firstWhere(
              (MessageImage image) => image.order == imageIndex + 1,
            );
            final int currentRow = (imageIndex ~/ maxImagesInRow) + 1;
            int imagesInRow = currentRow == numberOfAllRows
                ? numberOfImagesInLastRow
                : maxImagesInRow;
            final double width = imagesInRow == 1
                ? double.infinity
                : (maxMessageWidth - 2 * cardPadding) / imagesInRow;
            final double? height = imagesInRow == 1 ? null : 90;

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _onTap(context, image),
                child: Container(
                  width: width,
                  height: height,
                  constraints: const BoxConstraints(maxHeight: 400),
                  padding: EdgeInsets.only(
                    right: imageIndex < imagesInRow - 1 ? 8 : 0,
                    bottom: currentRow != numberOfAllRows ? 8 : 0,
                  ),
                  child: Image.memory(image.bytes, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),
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
