import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../domain/cubit/internet_connection_cubit.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/nullable_text_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/notifications/notifications_cubit.dart';
import '../../../feature/dialog/person_details/person_details_dialog.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'cubit/coach/profile_coach_cubit.dart';
import 'profile_no_coach_content.dart';

class ProfileCoachSection extends StatelessWidget {
  const ProfileCoachSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLarge(Str.of(context).profileCoach),
          const Gap16(),
          const _Content(),
        ],
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final bool? isInternetConnection = context.select(
      (InternetConnectionCubit cubit) => cubit.state,
    );
    final bool doesCoachExist = context.select(
      (ProfileCoachCubit cubit) => cubit.state.doesCoachExist,
    );

    return switch (isInternetConnection) {
      null => const LoadingInfo(),
      false => EmptyContentInfo(
          icon: Icons.wifi_off,
          subtitle: Str.of(context).noInternetConnection,
        ),
      true => doesCoachExist ? const _Coach() : const ProfileNoCoachContent(),
    };
  }
}

class _Coach extends StatelessWidget {
  const _Coach();

  @override
  Widget build(BuildContext context) {
    final String? coachFullName = context.select(
      (ProfileCoachCubit cubit) => cubit.state.coachFullName,
    );
    final String? coachEmail = context.select(
      (ProfileCoachCubit cubit) => cubit.state.coachEmail,
    );

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8),
      title: NullableText(coachFullName),
      subtitle: NullableText(coachEmail),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _onOpenChat(context),
            icon: const _UnreadCoachMessagesBadge(
              child: Icon(Icons.chat_outlined),
            ),
          ),
          IconButton(
            onPressed: () => _onShowDetails(context),
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: () => _onDelete(context),
            icon: const Icon(Icons.person_remove_outlined),
          ),
        ],
      ),
    );
  }

  Future<void> _onOpenChat(BuildContext context) async {
    final ProfileCoachCubit cubit = context.read<ProfileCoachCubit>();
    final bool hasStillCoach = await cubit.checkIfStillHasCoach();
    if (hasStillCoach) {
      final String? chatId = await cubit.loadChatId();
      navigateTo(ChatRoute(chatId: chatId));
    }
  }

  Future<void> _onShowDetails(BuildContext context) async {
    final ProfileCoachCubit cubit = context.read<ProfileCoachCubit>();
    final bool hasStillCoach = await cubit.checkIfStillHasCoach();
    if (hasStillCoach) {
      final String? coachId = cubit.state.coachId;
      if (coachId != null) {
        showDialogDependingOnScreenSize(PersonDetailsDialog(
          personId: coachId,
          personType: PersonType.coach,
        ));
      }
    }
  }

  Future<void> _onDelete(BuildContext context) async {
    final ProfileCoachCubit cubit = context.read<ProfileCoachCubit>();
    final bool isDeletionConfirmed =
        await _askForCoachDeletionConfirmation(context);
    if (isDeletionConfirmed) cubit.deleteCoach();
  }

  Future<bool> _askForCoachDeletionConfirmation(BuildContext context) async =>
      await askForConfirmation(
        title: Text(
          Str.of(context).profileFinishCooperationWithCoachDialogTitle,
        ),
        content: Text(
          Str.of(context).profileFinishCooperationWithCoachDialogMessage,
        ),
        displayConfirmationButtonAsFilled: true,
        confirmButtonColor: Theme.of(context).colorScheme.error,
      );
}

class _UnreadCoachMessagesBadge extends StatelessWidget {
  final Widget child;

  const _UnreadCoachMessagesBadge({required this.child});

  @override
  Widget build(BuildContext context) {
    final bool? areThereUnreadMessagesFromCoach = context.select(
      (NotificationsCubit cubit) => cubit.state.areThereUnreadMessagesFromCoach,
    );

    return Badge(
      isLabelVisible: areThereUnreadMessagesFromCoach == true,
      child: child,
    );
  }
}
