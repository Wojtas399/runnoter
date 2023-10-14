import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'cubit/chat_cubit.dart';
import '../../../../domain/cubit/internet_connection_cubit.dart';
import '../../../component/dialog/actions_dialog_component.dart';
import '../../../service/dialog_service.dart';
import '../../../service/image_service.dart';
import '../../../service/utils.dart';
import 'chat_message_input_images.dart';

class ChatBottomPart extends StatefulWidget {
  const ChatBottomPart({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatBottomPart> {
  final TextEditingController _messageController = TextEditingController();
  bool _isMessageSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 0),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const ChatMessageInputImages(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(
                              left: kIsWeb ? 8 : 0,
                              top: kIsWeb ? 4 : 0,
                            ),
                            child: _ImageButton(),
                          ),
                          Expanded(
                            child: _MessageInput(
                              messageController: _messageController,
                              onSubmitted: () => _onSubmit(context),
                              isDisabled: _isMessageSubmitting,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: kIsWeb ? 4 : 0),
                child: _SubmitButton(
                  onPressed: () => _onSubmit(context),
                  isLoading: _isMessageSubmitting,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    setState(() {
      _isMessageSubmitting = true;
    });
    await context.read<ChatCubit>().submitMessage();
    _messageController.clear();
    setState(() {
      _isMessageSubmitting = false;
    });
  }
}

class _ImageButton extends StatefulWidget {
  const _ImageButton();

  @override
  State<StatefulWidget> createState() => _ImageButtonState();
}

class _ImageButtonState extends State<_ImageButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _onImagePressed,
      icon: const Icon(Icons.image_outlined),
    );
  }

  Future<void> _onImagePressed() async {
    final ImageSource? imageSource =
        kIsWeb ? ImageSource.gallery : await _askForImageSource();
    if (imageSource == null) return;
    switch (imageSource) {
      case ImageSource.gallery:
        await _pickImagesFromGallery();
      case ImageSource.camera:
        await _capturePhotoFromCamera();
    }
  }

  Future<ImageSource?> _askForImageSource() async => await askForAction(
        actions: [
          ActionsDialogItem(
            icon: const Icon(Icons.photo_library),
            label: Str.of(context).chatPickImagesFromGallery,
            value: ImageSource.gallery,
          ),
          ActionsDialogItem(
            icon: const Icon(Icons.camera_alt),
            label: Str.of(context).chatCapturePhotoFromCamera,
            value: ImageSource.camera,
          ),
        ],
      );

  Future<void> _pickImagesFromGallery() async {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final List<Uint8List> images = await pickMultipleImages();
    if (images.isNotEmpty) chatCubit.addImagesToSend(images);
  }

  Future<void> _capturePhotoFromCamera() async {
    final ChatCubit chatCubit = context.read<ChatCubit>();
    final Uint8List? image = await capturePhoto();
    if (image != null) chatCubit.addImagesToSend([image]);
  }
}

class _MessageInput extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSubmitted;
  final bool isDisabled;

  const _MessageInput({
    required this.messageController,
    required this.onSubmitted,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
    const double contentPadding = kIsWeb ? 16 : 8;
    final bool? isInternetConnection = context.select(
      (InternetConnectionCubit cubit) => cubit.state,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: TextField(
        decoration: InputDecoration(
          border: border,
          focusedBorder: border,
          enabledBorder: border,
          disabledBorder: border,
          errorBorder: border,
          hintText: Str.of(context).chatWriteMessage,
          contentPadding: const EdgeInsets.fromLTRB(
            kIsWeb ? 8 : 0,
            contentPadding,
            contentPadding,
            contentPadding,
          ),
          counterText: '',
        ),
        enabled: isInternetConnection == false ? false : !isDisabled,
        maxLength: 500,
        maxLines: null,
        textInputAction: TextInputAction.send,
        controller: messageController,
        onChanged: context.read<ChatCubit>().messageChanged,
        onTapOutside: (_) => unfocusInputs(),
        onSubmitted: (_) => onSubmitted(),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isLoading;

  const _SubmitButton({required this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final bool? isInternetConnection = context.select(
      (InternetConnectionCubit cubit) => cubit.state,
    );
    final bool canSubmit = context.select(
      (ChatCubit cubit) => cubit.state.canSubmitMessage,
    );

    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
      ),
      onPressed: isInternetConnection == false || isLoading || !canSubmit
          ? null
          : onPressed,
      child: isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(2),
              child: const CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.send),
    );
  }
}
