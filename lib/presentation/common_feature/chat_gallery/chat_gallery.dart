import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/chat_gallery_cubit.dart';
import '../../../domain/entity/message_image.dart';
import '../../component/loading_info_component.dart';
import '../../dialog/chat_image_preview/chat_image_preview_dialog.dart';
import '../../service/dialog_service.dart';

class ChatGallery extends StatelessWidget {
  final String chatId;

  const ChatGallery({super.key, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatGalleryCubit(chatId: chatId)..initialize(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Str.of(context).chatGalleryTitle),
        leading: const CloseButton(),
      ),
      body: const _Images(),
    );
  }
}

class _Images extends StatelessWidget {
  const _Images();

  @override
  Widget build(BuildContext context) {
    final List<MessageImage>? images = context.select(
      (ChatGalleryCubit cubit) => cubit.state,
    );

    return images == null
        ? const LoadingInfo()
        : GridView.builder(
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
          );
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
