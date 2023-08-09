import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/additional_model/user_basic_info.dart';
import '../../../domain/bloc/users_search/users_search_bloc.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../component/padding/paddings_24.dart';
import '../../extension/gender_extensions.dart';

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
      },
    );
  }

  void _inviteUser(BuildContext context) {
    context.read<UsersSearchBloc>().add(
          UsersSearchEventInviteUser(idOfUserToInvite: foundUser.info.id),
        );
  }
}
