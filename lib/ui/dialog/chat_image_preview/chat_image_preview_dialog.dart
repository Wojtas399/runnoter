import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/message_image.dart';
import '../../component/loading_info_component.dart';
import '../../cubit/chat_image_preview/chat_image_preview_cubit.dart';
import 'chat_image_preview_all_images.dart';
import 'chat_image_preview_gallery.dart';

class ChatImagePreviewDialog extends StatelessWidget {
  final String chatId;
  final MessageImage selectedImage;

  const ChatImagePreviewDialog({
    super.key,
    required this.chatId,
    required this.selectedImage,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatImagePreviewCubit(
        chatId: chatId,
        initialState: ChatImagePreviewState(selectedImage: selectedImage),
      )..initialize(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: _ImagesContent(),
        ),
      ),
    );
  }
}

class _ImagesContent extends StatelessWidget {
  const _ImagesContent();

  @override
  Widget build(BuildContext context) {
    final ChatImagePreviewState cubitState =
        context.watch<ChatImagePreviewCubit>().state;

    return cubitState.images == null && cubitState.selectedImage != null
        ? const LoadingInfo(textColor: Colors.white)
        : const Column(
            children: [
              Expanded(
                child: kIsWeb
                    ? Row(
                        children: [
                          _PreviousImageButton(),
                          Expanded(
                            child: ChatImagePreviewSelectedImage(),
                          ),
                          _NextImageButton()
                        ],
                      )
                    : ChatImagePreviewSelectedImage(),
              ),
              SizedBox(
                height: 75,
                child: ChatImagePreviewAllImages(),
              ),
            ],
          );
  }
}

class _PreviousImageButton extends StatelessWidget {
  const _PreviousImageButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ChatImagePreviewCubit cubit) => cubit.state.isSelectedImageFirstOne,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: IconButton(
        color: Colors.white,
        disabledColor: Colors.white.withOpacity(0.5),
        onPressed: isDisabled
            ? null
            : context.read<ChatImagePreviewCubit>().previousImage,
        icon: const Icon(Icons.arrow_back_ios),
      ),
    );
  }
}

class _NextImageButton extends StatelessWidget {
  const _NextImageButton();

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = context.select(
      (ChatImagePreviewCubit cubit) => cubit.state.isSelectedImageLastOne,
    );

    return Padding(
      padding: const EdgeInsets.all(16),
      child: IconButton(
        color: Colors.white,
        disabledColor: Colors.white.withOpacity(0.5),
        onPressed:
            isDisabled ? null : context.read<ChatImagePreviewCubit>().nextImage,
        icon: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
