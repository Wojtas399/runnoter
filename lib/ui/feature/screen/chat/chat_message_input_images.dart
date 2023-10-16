import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../component/gap/gap_horizontal_components.dart';
import '../../../cubit/chat/chat_cubit.dart';

class ChatMessageInputImages extends StatelessWidget {
  const ChatMessageInputImages({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Uint8List>? images = context.select(
      (ChatCubit cubit) => cubit.state.imagesToSend,
    );

    return images != null
        ? Container(
            height: images.isEmpty ? 0 : 130,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: ListView.separated(
              physics: const _StartAtTheEndScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              separatorBuilder: (_, int index) => const GapHorizontal8(),
              itemBuilder: (_, int imageIndex) => _ImageItem(
                imageIndex: imageIndex,
                imageData: images[imageIndex],
              ),
            ),
          )
        : const SizedBox();
  }
}

class _ImageItem extends StatelessWidget {
  final int imageIndex;
  final Uint8List imageData;

  const _ImageItem({required this.imageIndex, required this.imageData});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomLeft,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.memory(imageData),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: _DeleteButton(
            onPressed: () =>
                context.read<ChatCubit>().deleteImageToSend(imageIndex),
          ),
        ),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _DeleteButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 26,
      height: 26,
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: const Icon(Icons.delete_outlined, size: 18),
      ),
    );
  }
}

class _StartAtTheEndScrollPhysics extends ScrollPhysics {
  const _StartAtTheEndScrollPhysics({super.parent});

  @override
  _StartAtTheEndScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return _StartAtTheEndScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    return newPosition.maxScrollExtent;
  }
}
