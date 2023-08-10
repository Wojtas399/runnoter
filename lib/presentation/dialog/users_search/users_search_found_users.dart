import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/bloc/users_search/users_search_bloc.dart';
import '../../../domain/entity/user_basic_info.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../extension/gender_extensions.dart';
import '../../service/dialog_service.dart';

class UsersSearchFoundUsers extends StatelessWidget {
  const UsersSearchFoundUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (UsersSearchBloc bloc) => bloc.state.status,
    );
    final List<FoundUser>? foundUsers = context.select(
      (UsersSearchBloc bloc) => bloc.state.foundUsers,
    );
    final str = Str.of(context);

    return blocStatus is BlocStatusLoading
        ? LoadingInfo(loadingText: str.usersSearchSearchingInfo)
        : switch (foundUsers) {
            null => Paddings24(
                child: EmptyContentInfo(title: str.usersSearchInstruction),
              ),
            [] => EmptyContentInfo(title: str.usersSearchNoResultsInfo),
            [...] => ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: foundUsers.map((FoundUser user) => _UserItem(user)),
                ).toList(),
              ),
          };
  }
}

class _UserItem extends StatelessWidget {
  final FoundUser foundUser;

  const _UserItem(this.foundUser);

  @override
  Widget build(BuildContext context) {
    final UserBasicInfo userInfo = foundUser.info;

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
    final UsersSearchBloc bloc = context.read<UsersSearchBloc>();
    final bool confirmed = await _askForConfirmationToSendInvitation(context);
    if (confirmed) {
      bloc.add(UsersSearchEventInviteUser(idOfUserToInvite: foundUser.info.id));
    }
  }

  Future<bool> _askForConfirmationToSendInvitation(
    BuildContext context,
  ) async {
    final str = Str.of(context);
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    return askForConfirmation(
      title: Text(str.usersSearchSendInvitationConfirmationDialogTitle),
      displaySubmitButtonAsFilled: true,
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str.usersSearchSendInvitationConfirmationDialogMessage,
              style: textStyle,
            ),
            TextSpan(
              text:
                  '${foundUser.info.name} ${foundUser.info.surname} (${foundUser.info.email})',
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
