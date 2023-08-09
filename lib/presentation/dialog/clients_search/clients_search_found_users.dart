import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/bloc_status.dart';
import '../../../domain/additional_model/user_basic_info.dart';
import '../../../domain/bloc/clients_search/clients_search_bloc.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/loading_info_component.dart';
import '../../extension/gender_extensions.dart';

class ClientsSearchFoundUsers extends StatelessWidget {
  const ClientsSearchFoundUsers({super.key});

  @override
  Widget build(BuildContext context) {
    final BlocStatus blocStatus = context.select(
      (ClientsSearchBloc bloc) => bloc.state.status,
    );
    final List<UserBasicInfo>? foundUsers = context.select(
      (ClientsSearchBloc bloc) => bloc.state.foundUsers,
    );

    return blocStatus is BlocStatusLoading
        ? LoadingInfo(loadingText: Str.of(context).usersSearchSearchingInfo)
        : switch (foundUsers) {
            null => const SizedBox(),
            [] => EmptyContentInfo(
                title: Str.of(context).usersSearchNoResultsInfo,
              ),
            [...] => ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: foundUsers.map(
                    (UserBasicInfo userInfo) => _UserItem(userInfo: userInfo),
                  ),
                ).toList(),
              ),
          };
  }
}

class _UserItem extends StatelessWidget {
  final UserBasicInfo userInfo;

  const _UserItem({required this.userInfo});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${userInfo.name} ${userInfo.surname}'),
      subtitle: Text(userInfo.email),
      leading: Icon(userInfo.gender.toIconData()),
      trailing: FilledButton(
        style: FilledButton.styleFrom(padding: const EdgeInsets.all(0)),
        onPressed: () => _inviteUser(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _inviteUser(BuildContext context) {
    //TODO
  }
}
