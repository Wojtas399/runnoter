import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../data/entity/message_image.dart';
import '../../../component/animated_refresh_indicator.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/padding/paddings_24.dart';
import '../../../cubit/chat_gallery_cubit.dart';
import '../../../service/dialog_service.dart';
import '../../dialog/chat_image_preview/chat_image_preview_dialog.dart';

class ChatGallery extends StatelessWidget {
  final String chatId;

  const ChatGallery({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatGalleryCubit(chatId: chatId)..initialize(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(Str.of(context).chatGalleryTitle),
          leading: const CloseButton(),
        ),
        body: const _Content(),
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  StreamSubscription<int>? _numberOfMessagesListener;
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isEndOfList = false;

  @override
  void initState() {
    _numberOfMessagesListener ??= context
        .read<ChatGalleryCubit>()
        .stream
        .map((List<MessageImage>? images) => images?.length)
        .whereNotNull()
        .distinct()
        .listen(
          (_) => setState(() {
            _isEndOfList = false;
          }),
        );
    _scrollController.addListener(_onScrollPositionChanged);
    super.initState();
  }

  @override
  void dispose() {
    _numberOfMessagesListener?.cancel();
    _numberOfMessagesListener = null;
    _scrollController.removeListener(_onScrollPositionChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Images(scrollController: _scrollController),
        AnimatedRefreshIndicator(
          isLoading: _isLoading,
          position: AnimatedRefreshIndicatorPosition.bottom,
        ),
      ],
    );
  }

  Future<void> _onScrollPositionChanged() async {
    final ScrollPosition scrollPosition = _scrollController.position;
    final bool isUpScrolling =
        scrollPosition.userScrollDirection == ScrollDirection.reverse;
    if (!_isEndOfList &&
        !_isLoading &&
        isUpScrolling &&
        scrollPosition.extentAfter < 10) {
      setState(() {
        _isLoading = true;
      });
      await context.read<ChatGalleryCubit>().loadOlderImages();
      setState(() {
        _isEndOfList = true;
        _isLoading = false;
      });
    }
  }
}

class _Images extends StatelessWidget {
  final ScrollController? scrollController;

  const _Images({this.scrollController});

  @override
  Widget build(BuildContext context) {
    final List<MessageImage>? images = context.select(
      (ChatGalleryCubit cubit) => cubit.state,
    );

    return switch (images) {
      null => const LoadingInfo(),
      [] => Paddings24(
          child: EmptyContentInfo(
            icon: Icons.image,
            title: Str.of(context).chatGalleryNoImagesInfoTitle,
            subtitle: Str.of(context).chatGalleryNoImagesInfoMessage,
          ),
        ),
      [...] => GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
          ),
          itemCount: images.length,
          itemBuilder: (_, int itemIndex) {
            final MessageImage image = images[itemIndex];

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => _onImageTap(context, image),
                child: Image.memory(image.bytes, fit: BoxFit.cover),
              ),
            );
          },
        ),
    };
  }

  void _onImageTap(BuildContext context, MessageImage image) {
    showFullScreenDialog(
      ChatImagePreviewDialog(
        chatId: context.read<ChatGalleryCubit>().chatId,
        selectedImage: image,
      ),
    );
  }
}
