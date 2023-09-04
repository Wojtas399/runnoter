import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/nullable_text_component.dart';
import '../../service/utils.dart';
import 'chat_messages.dart';

class ChatContent extends StatelessWidget {
  const ChatContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const _RecipientFullName(),
      ),
      body: SafeArea(
        child: BigBody(
          child: RefreshIndicator(
            onRefresh: () async =>
                await context.read<ChatCubit>().loadOlderMessages(),
            child: Column(
              children: [
                const Expanded(
                  child: ChatMessages(),
                ),
                _BottomPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecipientFullName extends StatelessWidget {
  const _RecipientFullName();

  @override
  Widget build(BuildContext context) {
    final String? recipientFullName = context.select(
      (ChatCubit cubit) => cubit.state.recipientFullName,
    );

    return NullableText(recipientFullName);
  }
}

class _BottomPart extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: _MessageInput(
              messageController: _messageController,
              onSubmitted: () => _onSubmit(context),
            ),
          ),
          const GapHorizontal8(),
          SizedBox(
            width: 40,
            child: _SubmitButton(
              onPressed: () => _onSubmit(context),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    await context.read<ChatCubit>().submitMessage();
    _messageController.clear();
  }
}

class _MessageInput extends StatefulWidget {
  final TextEditingController messageController;
  final VoidCallback onSubmitted;

  const _MessageInput({
    required this.messageController,
    required this.onSubmitted,
  });

  @override
  State<StatefulWidget> createState() => _MessageInputState();
}

class _MessageInputState extends State<_MessageInput> {
  int _messageLength = 0;

  @override
  void initState() {
    widget.messageController.addListener(_onChanged);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (ChatCubit cubit) => cubit.state.status,
    );

    return TextField(
      decoration: InputDecoration(
        hintText: Str.of(context).chatWriteMessage,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        counterText: '',
        suffixText: '$_messageLength/100',
      ),
      enabled: blocStatus is! BlocStatusLoading,
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

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (ChatCubit cubit) => cubit.state.status,
    );
    final bool canSubmit = context.select(
      (ChatCubit cubit) => cubit.state.canSubmitMessage,
    );

    return blocStatus is BlocStatusLoading
        ? Transform.scale(
            scale: 0.7,
            child: const CircularProgressIndicator(),
          )
        : IconButton(
            color: Theme.of(context).colorScheme.primary,
            onPressed: canSubmit ? onPressed : null,
            icon: const Icon(Icons.send),
          );
  }
}
