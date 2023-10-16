import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/message_image.dart';
import '../../cubit/chat_image_preview/chat_image_preview_cubit.dart';

class ChatImagePreviewAllImages extends StatelessWidget {
  const ChatImagePreviewAllImages({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatImagePreviewState cubitState =
        context.watch<ChatImagePreviewCubit>().state;
    final List<MessageImage> images = cubitState.images!;

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: images.length,
      itemBuilder: (_, int imageIndex) {
        final MessageImage image = images[imageIndex];

        return _Image(
          image: image,
          isSelected: image.id == cubitState.selectedImage!.id,
          isFirstInList: imageIndex == 0,
          isLastInList: imageIndex == images.length - 1,
        );
      },
    );
  }
}

class _Image extends StatelessWidget {
  final MessageImage image;
  final bool isSelected;
  final bool isFirstInList;
  final bool isLastInList;

  const _Image({
    required this.image,
    required this.isSelected,
    required this.isFirstInList,
    required this.isLastInList,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () =>
            context.read<ChatImagePreviewCubit>().imageSelected(image.id),
        child: Opacity(
          opacity: isSelected ? 1 : 0.5,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isFirstInList ? 16 : 8,
              8,
              isLastInList ? 16 : 8,
              8,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.hardEdge,
              child: Image.memory(image.bytes),
            ),
          ),
        ),
      ),
    );
  }
}
