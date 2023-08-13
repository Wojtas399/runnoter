import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/coaching_request.dart';
import '../../../domain/bloc/profile/coach/profile_coach_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../dialog/persons_search/persons_search_dialog.dart';
import '../../service/dialog_service.dart';

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
          const _Coach(),
        ],
      ),
    );
  }
}

class _Coach extends StatelessWidget {
  const _Coach();

  @override
  Widget build(BuildContext context) {
    final Person? coach = context.select(
      (ProfileCoachBloc bloc) => bloc.state.coach,
    );

    return coach == null
        ? const _NoCoachContent()
        : ListTile(
            contentPadding: const EdgeInsets.only(left: 8),
            title: Text('${coach.name} ${coach.surname}'),
            subtitle: Text(coach.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () => _onMessagePressed(context),
                  child: Text(Str.of(context).message),
                ),
                const GapHorizontal8(),
                IconButton(
                  onPressed: () => _onDeletePressed(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                  ),
                ),
              ],
            ),
          );
  }

  void _onMessagePressed(BuildContext context) {
    //TODO
  }

  Future<void> _onDeletePressed(BuildContext context) async {
    final ProfileCoachBloc bloc = context.read<ProfileCoachBloc>();
    final bool isDeletionConfirmed =
        await _askForCoachDeletionConfirmation(context);
    if (isDeletionConfirmed) {
      bloc.add(const ProfileCoachEventDeleteCoach());
    }
  }

  Future<bool> _askForCoachDeletionConfirmation(BuildContext context) async =>
      await askForConfirmation(
        title: Text(
          Str.of(context).profileFinishCooperationWithCoachDialogTitle,
        ),
        content: Text(
          Str.of(context).profileFinishCooperationWithCoachDialogMessage,
        ),
        displaySubmitButtonAsFilled: true,
        confirmButtonColor: Theme.of(context).colorScheme.error,
      );
}

class _NoCoachContent extends StatelessWidget {
  const _NoCoachContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TitleMedium(Str.of(context).profileNoCoachTitle),
        const Gap8(),
        BodyMedium(
          Str.of(context).profileNoCoachMessage,
          textAlign: TextAlign.center,
          color: Theme.of(context).colorScheme.outline,
        ),
        const Gap16(),
        FilledButton(
          onPressed: () => _onFindCoachPressed(),
          child: Text(Str.of(context).profileFindCoach),
        ),
        const Gap24(),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TitleMedium(Str.of(context).profileCoachingRequests),
          ],
        ),
        const Gap8(),
        const _CoachingRequests(),
      ],
    );
  }

  void _onFindCoachPressed() {
    showDialogDependingOnScreenSize(
      const PersonsSearchDialog(
        requestDirection: CoachingRequestDirection.clientToCoach,
      ),
    );
  }
}

class _CoachingRequests extends StatelessWidget {
  const _CoachingRequests();

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestInfo>? requests = context.select(
      (ProfileCoachBloc bloc) => bloc.state.receivedCoachingRequests,
    );

    return switch (requests) {
      null => const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: CircularProgressIndicator(),
        ),
      [] => Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: BodyMedium(
            Str.of(context).profileNoRequestsInfo,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      [...] => ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: ListTile.divideTiles(
            context: context,
            tiles: requests.map((request) => _CoachingRequestItem(request)),
          ).toList(),
        ),
    };
  }
}

class _CoachingRequestItem extends StatelessWidget {
  final CoachingRequestInfo requestInfo;

  const _CoachingRequestItem(this.requestInfo);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      title: Text('${requestInfo.sender.name} ${requestInfo.sender.surname}'),
      subtitle: Text(requestInfo.sender.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _onAccept(context),
            icon: Icon(
              Icons.check,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          IconButton(
            onPressed: () => _onDelete(context),
            icon: Icon(
              Icons.close,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _onAccept(BuildContext context) {
    context.read<ProfileCoachBloc>().add(
          ProfileCoachEventAcceptRequest(requestId: requestInfo.id),
        );
  }

  void _onDelete(BuildContext context) {
    context.read<ProfileCoachBloc>().add(
          ProfileCoachEventDeleteRequest(requestId: requestInfo.id),
        );
  }
}
