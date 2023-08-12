import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/gender_extensions.dart';

class ClientsList extends StatelessWidget {
  const ClientsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.isMobileSize ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobileSize ? 8 : 0,
            ),
            child: TitleLarge(Str.of(context).clientsTitle),
          ),
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
    final List<Person>? clients = context.select(
      (ClientsBloc bloc) => bloc.state.clients,
    );

    return switch (clients) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          title: Str.of(context).clientsNoClientsTitle,
          subtitle: Str.of(context).clientsNoClientsMessage,
        ),
      [...] => const Text('Users exist!'),
    };
  }
}

class _ClientItem extends StatelessWidget {
  final Person clientInfo;

  const _ClientItem(this.clientInfo);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${clientInfo.name} ${clientInfo.surname}'),
      subtitle: Text(clientInfo.email),
      leading: Icon(clientInfo.gender.toIconData()),
      trailing: OutlinedButton(
        onPressed: () => _onMessagePressed(),
        child: Text(Str.of(context).clientsMessage),
      ),
    );
  }

  void _onMessagePressed() {
    //TODO
  }
}
