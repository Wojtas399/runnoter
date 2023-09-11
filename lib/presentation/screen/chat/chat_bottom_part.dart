import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/additional_model/cubit_status.dart';
import '../../../domain/cubit/chat/chat_cubit.dart';
import 'chat_message_input.dart';

class ChatBottomPart extends StatelessWidget {
  final TextEditingController _messageController = TextEditingController();

  ChatBottomPart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 8, 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ChatMessageInput(
                  messageController: _messageController,
                  onSubmitted: () => _onSubmit(context),
                ),
              ),
              _SubmitButton(
                onPressed: () => _onSubmit(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _onSubmit(BuildContext context) async {
    await context.read<ChatCubit>().submitMessage();
    _messageController.clear();
  }
}

class _SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SubmitButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (ChatCubit cubit) => cubit.state.status,
    );
    final bool canSubmit = context.select(
      (ChatCubit cubit) => cubit.state.canSubmitMessage,
    );

    return FilledButton(
      style: FilledButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(kIsWeb ? 16 : 8),
      ),
      onPressed:
          cubitStatus is! CubitStatusLoading && canSubmit ? onPressed : null,
      child: cubitStatus is CubitStatusLoading
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
