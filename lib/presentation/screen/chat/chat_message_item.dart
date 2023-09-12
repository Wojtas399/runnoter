import 'package:flutter/material.dart';

import '../../../common/date_service.dart';
import '../../../dependency_injection.dart';
import '../../../domain/entity/message.dart';
import '../../component/gap/gap_components.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/label_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/widgets_list_extensions.dart';
import '../../formatter/date_formatter.dart';

class ChatMessageItem extends StatelessWidget {
  final bool isSender;
  final String? text;
  final List<MessageImage> images;
  final DateTime dateTime;

  const ChatMessageItem({
    super.key,
    required this.isSender,
    required this.text,
    required this.images,
    required this.dateTime,
  });

  @override
  Widget build(BuildContext context) {
    return text?.isNotEmpty == true || images.isNotEmpty
        ? Row(
            mainAxisAlignment:
                isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: isSender
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  _MessageCloud(isSender: isSender, text: text, images: images),
                  _SendDateTime(dateTime: dateTime),
                ],
              ),
            ],
          )
        : const SizedBox();
  }
}

class _MessageCloud extends StatelessWidget {
  final bool isSender;
  final String? text;
  final List<MessageImage> images;

  const _MessageCloud({
    required this.isSender,
    required this.text,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    const Radius borderRadius = Radius.circular(16);
    final ThemeData theme = Theme.of(context);
    const double maxMessageWidth = 300;
    const double cardPadding = 12;

    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
          bottomLeft: isSender ? borderRadius : Radius.zero,
          bottomRight: isSender ? Radius.zero : borderRadius,
        ),
      ),
      color: isSender
          ? theme.colorScheme.primary
          : theme.colorScheme.surfaceVariant,
      child: Container(
        constraints: const BoxConstraints(maxWidth: maxMessageWidth),
        padding: const EdgeInsets.all(cardPadding),
        child: Column(
          crossAxisAlignment:
              isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (images.isNotEmpty)
              _Images(
                images: images,
                doesTextExist: text != null,
                maxMessageWidth: maxMessageWidth,
                cardPadding: cardPadding,
                isSender: isSender,
              ),
            if (text?.isNotEmpty == true)
              BodyMedium(
                text!,
                color: isSender ? Theme.of(context).canvasColor : null,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
          bottomLeft: doesTextExist ? Radius.zero : borderRadius,
        ),
      ),
      child: Wrap(
        alignment: isSender ? WrapAlignment.end : WrapAlignment.start,
        children: List.generate(
          numberOfImages,
          (int imageIndex) {
            final int currentRow = (imageIndex ~/ maxImagesInRow) + 1;
            int imagesInRow = currentRow == numberOfAllRows
                ? numberOfImagesInLastRow
                : maxImagesInRow;
            final double? width = imagesInRow == 1
                ? null
                : (maxMessageWidth - 2 * cardPadding) / imagesInRow;
            final double? height = imagesInRow == 1 ? null : 90;

            return Container(
              width: width,
              height: height,
              constraints: const BoxConstraints(maxHeight: 400),
              padding: EdgeInsets.only(
                right: imageIndex < imagesInRow - 1 ? 8 : 0,
                bottom: currentRow != numberOfAllRows ? 8 : 0,
              ),
              child: Image.memory(
                images[imageIndex].data,
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SendDateTime extends StatelessWidget {
  final DateService _dateService = getIt<DateService>();
  final DateTime dateTime;

  _SendDateTime({required this.dateTime});

  @override
  Widget build(BuildContext context) {
    String dateStr = dateTime.toDateWithTime(context.languageCode);
    if (_dateService.isToday(dateTime)) dateStr = dateTime.toTime();

    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: LabelSmall(
        dateStr,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}
