import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../../domain/cubit/chat_gallery/chat_gallery_cubit.dart';
import '../../../domain/cubit/chat_gallery/chat_gallery_state.dart';
import '../../../domain/entity/message.dart';

class ChatImagePreviewSelectedImage extends StatefulWidget {
  const ChatImagePreviewSelectedImage({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatImagePreviewSelectedImage> {
  late final PageController _pageController;
  StreamSubscription<ChatGalleryState>? _cubitStateListener;

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
      (ChatGalleryCubit cubit) => cubit.state.images!,
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
      onPageChanged: (int imageIndex) =>
          context.read<ChatGalleryCubit>().imageSelected(images[imageIndex].id),
    );
  }

  void _setInitialPage() {
    final ChatGalleryCubit cubit = context.read<ChatGalleryCubit>();
    final int initialPage = cubit.state.images!.indexWhere(
      (image) => image.id == cubit.state.selectedImage!.id,
    );
    _pageController = PageController(initialPage: initialPage);
  }

  void _setCubitStateListener() {
    _cubitStateListener ??= context
        .read<ChatGalleryCubit>()
        .stream
        .where((state) => state.images != null && state.selectedImage != null)
        .distinct()
        .listen(_cubitStateUpdated);
  }

  void _cubitStateUpdated(ChatGalleryState state) {
    final int page = state.images!.indexWhere(
      (image) => image.id == state.selectedImage!.id,
    );
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }
}
