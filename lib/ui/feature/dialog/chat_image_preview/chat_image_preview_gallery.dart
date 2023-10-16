import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../../data/entity/message_image.dart';
import '../../../cubit/chat_image_preview/chat_image_preview_cubit.dart';

class ChatImagePreviewSelectedImage extends StatefulWidget {
  const ChatImagePreviewSelectedImage({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatImagePreviewSelectedImage> {
  late final PageController _pageController;
  StreamSubscription<ChatImagePreviewState>? _cubitStateListener;

  @override
  void initState() {
    _setInitialPage();
    _setCubitStateListener();
    super.initState();
  }

  @override
  void dispose() {
    _cubitStateListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<MessageImage> images = context.select(
      (ChatImagePreviewCubit cubit) => cubit.state.images!,
    );

    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) => PhotoViewGalleryPageOptions(
        imageProvider: MemoryImage(images[index].bytes),
        initialScale: PhotoViewComputedScale.contained * 1,
        heroAttributes: PhotoViewHeroAttributes(tag: 'h$index'),
      ),
      pageController: _pageController,
      itemCount: images.length,
      onPageChanged: (int imageIndex) => context
          .read<ChatImagePreviewCubit>()
          .imageSelected(images[imageIndex].id),
    );
  }

  void _setInitialPage() {
    final ChatImagePreviewCubit cubit = context.read<ChatImagePreviewCubit>();
    final int initialPage = cubit.state.images!.indexWhere(
      (image) => image.id == cubit.state.selectedImage!.id,
    );
    _pageController = PageController(initialPage: initialPage);
  }

  void _setCubitStateListener() {
    _cubitStateListener ??= context
        .read<ChatImagePreviewCubit>()
        .stream
        .where((state) => state.images != null && state.selectedImage != null)
        .distinct()
        .listen(_cubitStateUpdated);
  }

  void _cubitStateUpdated(ChatImagePreviewState state) {
    final int page = state.images!.indexWhere(
      (image) => image.id == state.selectedImage!.id,
    );
    _pageController.jumpToPage(page);
  }
}
