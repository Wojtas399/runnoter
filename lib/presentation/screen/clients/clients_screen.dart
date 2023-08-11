import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/clients_cubit.dart';
import '../../../domain/entity/person.dart';
import '../../component/big_button_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../dialog/persons_search/persons_search_dialog.dart';
import '../../extension/gender_extensions.dart';
import '../../service/dialog_service.dart';

@RoutePage()
class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsCubit()..initialize(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return MediumBody(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: ResponsiveLayout(
          mobileBody: const _Clients(),
          desktopBody: Column(
            children: [
              BigButton(
                label: Str.of(context).clientsSearchUsers,
                onPressed: () => showDialogDependingOnScreenSize(
                  const PersonsSearchDialog(),
                ),
              ),
              const Gap32(),
              const Expanded(
                child: _Clients(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Clients extends StatelessWidget {
  const _Clients();

  @override
  Widget build(BuildContext context) {
    final List<Person>? clients = context.select(
      (ClientsCubit cubit) => cubit.state,
    );

    return switch (clients) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          icon: Icons.groups,
          title: Str.of(context).clientsNoClientsTitle,
          subtitle: Str.of(context).clientsNoClientsMessage,
        ),
      [...] => ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: clients.map((Person client) => _ClientItem(client)),
          ).toList(),
        ),
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
