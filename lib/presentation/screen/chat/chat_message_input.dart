import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';

import '../../../domain/additional_model/cubit_status.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/dialog/actions_dialog_component.dart';
import '../../service/dialog_service.dart';
import '../../service/image_service.dart';
import '../../service/utils.dart';

class ChatMessageInput extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSubmitted;

  const ChatMessageInput({
    super.key,
    required this.messageController,
    required this.onSubmitted,
  });

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ChatMessageInput> {
  int _messageLength = 0;

  @override
  void initState() {
    widget.messageController.addListener(_onChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.surfaceVariant,
      ),
    );
    final CubitStatus cubitStatus = context.select(
      (ChatCubit cubit) => cubit.state.status,
    );

    return TextField(
      decoration: InputDecoration(
        filled: true,
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        disabledBorder: border,
        errorBorder: border,
        hintText: Str.of(context).chatWriteMessage,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        counterText: '',
        suffixText: ' $_messageLength/100',
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: kIsWeb ? 8 : 0, right: kIsWeb ? 8 : 0),
          child: _ImageButton(),
        ),
      ),
      enabled: cubitStatus is! CubitStatusLoading,
      maxLength: 100,
      textInputAction: TextInputAction.send,
      controller: widget.messageController,
      onTapOutside: (_) => unfocusInputs(),
      onSubmitted: (_) => widget.onSubmitted(),
    );
  }

  void _onChanged() {
    context.read<ChatCubit>().messageChanged(widget.messageController.text);
    setState(() {
      _messageLength = widget.messageController.text.length;
    });
  }
}

class _ImageButton extends StatelessWidget {
  const _ImageButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onImagePressed(context),
      icon: const Icon(Icons.image_outlined),
    );
  }

  Future<void> _onImagePressed(BuildContext context) async {
    final ImageSource? imageSource =
        kIsWeb ? ImageSource.gallery : await _askForImageSource(context);
    if (imageSource == null) return;
    switch (imageSource) {
      case ImageSource.gallery:
        await _pickImagesFromGallery();
      case ImageSource.camera:
        await _capturePhotoFromCamera();
    }
  }

  Future<ImageSource?> _askForImageSource(BuildContext context) async =>
      await askForAction(
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
    final List<Uint8List> images = await pickMultipleImages();
    if (images.isNotEmpty) {
      //TODO: Call chat cubit method
    }
  }

  Future<void> _capturePhotoFromCamera() async {
    final Uint8List? image = await capturePhoto();
    if (image != null) {
      //TODO: Call chat cubit method
    }
  }
}
