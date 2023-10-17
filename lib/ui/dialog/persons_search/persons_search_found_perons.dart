import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/interface/service/coaching_request_service.dart';
import '../../../../data/model/person.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../cubit/persons_search/persons_search_cubit.dart';
import '../../formatter/gender_formatter.dart';
import '../../formatter/person_formatter.dart';
import '../../model/cubit_status.dart';
import '../../service/dialog_service.dart';

class PersonsSearchFoundPersons extends StatelessWidget {
  const PersonsSearchFoundPersons({super.key});

  @override
  Widget build(BuildContext context) {
    final CubitStatus cubitStatus = context.select(
      (PersonsSearchCubit cubit) => cubit.state.status,
    );
    final List<FoundPerson>? foundUsers = context.select(
      (PersonsSearchCubit cubit) => cubit.state.foundPersons,
    );

    return cubitStatus is CubitStatusLoading
        ? LoadingInfo(loadingText: Str.of(context).loading)
        : switch (foundUsers) {
            null => const _EmptySearchQueryInfo(),
            [] => const _NoResultsInfo(),
            [...] => ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: foundUsers.map((FoundPerson user) => _UserItem(user)),
                ).toList(),
              ),
          };
  }
}

class _UserItem extends StatelessWidget {
  final FoundPerson foundUser;

  const _UserItem(this.foundUser);

  @override
  Widget build(BuildContext context) {
    final Person userInfo = foundUser.info;

    return ListTile(
      title: Text('${userInfo.name} ${userInfo.surname}'),
      subtitle: Text(userInfo.email),
      leading: Icon(userInfo.gender.toIconData()),
      trailing: switch (foundUser.relationshipStatus) {
        RelationshipStatus.notInvited => FilledButton(
            style: FilledButton.styleFrom(padding: const EdgeInsets.all(0)),
            onPressed: () => _inviteUser(context),
            child: const Icon(Icons.person_add),
          ),
        RelationshipStatus.pending => const Icon(Icons.access_time),
        RelationshipStatus.accepted => const Icon(Icons.check),
        RelationshipStatus.alreadyTaken => const Icon(
            Icons.do_not_disturb_on_outlined,
          ),
      },
    );
  }

  Future<void> _inviteUser(BuildContext context) async {
    final PersonsSearchCubit cubit = context.read<PersonsSearchCubit>();
    final bool confirmed = await _askForConfirmationToSendInvitation(context);
    if (confirmed) cubit.invitePerson(foundUser.info.id);
  }

  Future<bool> _askForConfirmationToSendInvitation(
    BuildContext context,
  ) async {
    final str = Str.of(context);
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final CoachingRequestDirection requestDirection =
        context.read<PersonsSearchCubit>().requestDirection;
    final String dialogTitle = switch (requestDirection) {
      CoachingRequestDirection.clientToCoach =>
        str.coachesSearchSendInvitationConfirmationDialogTitle,
      CoachingRequestDirection.coachToClient =>
        str.usersSearchSendInvitationConfirmationDialogTitle,
    };
    final String message = switch (requestDirection) {
      CoachingRequestDirection.clientToCoach =>
        str.coachesSearchSendInvitationConfirmationDialogMessage,
      CoachingRequestDirection.coachToClient =>
        str.usersSearchSendInvitationConfirmationDialogMessage,
    };

    return askForConfirmation(
      title: Text(dialogTitle),
      displayConfirmationButtonAsFilled: true,
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(text: message, style: textStyle),
            TextSpan(
              text: foundUser.info.toFullNameWithEmail(),
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: '?', style: textStyle),
          ],
        ),
      ),
      confirmButtonLabel: str.submit,
    );
  }
}

class _EmptySearchQueryInfo extends StatelessWidget {
  const _EmptySearchQueryInfo();

  @override
  Widget build(BuildContext context) {
    final CoachingRequestDirection requestDirection =
        context.read<PersonsSearchCubit>().requestDirection;
    final str = Str.of(context);
    final String title = switch (requestDirection) {
      CoachingRequestDirection.coachToClient => str.usersSearchInstruction,
      CoachingRequestDirection.clientToCoach => str.coachesSearchTitle,
    };

    return Paddings24(
      child: EmptyContentInfo(title: title),
    );
  }
}

class _NoResultsInfo extends StatelessWidget {
  const _NoResultsInfo();

  @override
  Widget build(BuildContext context) {
    final CoachingRequestDirection requestDirection =
        context.read<PersonsSearchCubit>().requestDirection;
    final str = Str.of(context);
    final String title = switch (requestDirection) {
      CoachingRequestDirection.clientToCoach => str.coachesSearchNoResultsInfo,
      CoachingRequestDirection.coachToClient => str.usersSearchNoResultsInfo,
    };

    return EmptyContentInfo(title: title);
  }
}
