import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/cubit/chat/chat_cubit.dart';
import '../../component/body/big_body_component.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/nullable_text_component.dart';
import '../../dialog/person_details/person_details_dialog.dart';
import '../../service/dialog_service.dart';
import 'chat_bottom_part.dart';
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
        actions: const [_DetailsIcon(), GapHorizontal8()],
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
                ChatBottomPart(),
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

class _DetailsIcon extends StatelessWidget {
  const _DetailsIcon();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _onPressed(context),
      icon: const Icon(Icons.info),
    );
  }

  void _onPressed(BuildContext context) {
    final String? recipientId = context.read<ChatCubit>().state.recipientId;
    if (recipientId != null) {
      showDialogDependingOnScreenSize(
        PersonDetailsDialog(
          personId: recipientId,
          personType: PersonType.coach,
        ),
      );
    }
  }
}
