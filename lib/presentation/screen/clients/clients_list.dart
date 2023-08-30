import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../extension/gender_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';

class ClientsList extends StatelessWidget {
  const ClientsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.isMobileSize ? 8 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobileSize ? 16 : 0,
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
      [...] => Column(
          children:
              clients.map((Person client) => _ClientItem(client)).toList(),
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.isMobileSize ? 16 : 0,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => _onShowProfile(),
            icon: Icon(
              Icons.assignment_ind,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          if (!context.isMobileSize) const GapHorizontal8(),
          IconButton(
            onPressed: () => _onDeleteClient(context),
            icon: Icon(
              Icons.person_remove,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _onShowProfile() {
    navigateTo(ClientRoute(clientId: clientInfo.id));
  }

  Future<void> _onDeleteClient(BuildContext context) async {
    final ClientsBloc bloc = context.read<ClientsBloc>();
    final bool isDeletionConfirmed =
        await _askForClientDeletionConfirmation(context);
    if (isDeletionConfirmed) {
      bloc.add(ClientsEventDeleteClient(clientId: clientInfo.id));
    }
  }

  Future<bool> _askForClientDeletionConfirmation(BuildContext context) async {
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final str = Str.of(context);

    return await askForConfirmation(
      title: Text(str.clientsDeleteClientConfirmationDialogTitle),
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str.clientsDeleteClientConfirmationDialogAreYouSure,
              style: textStyle,
            ),
            TextSpan(
              text:
                  '${clientInfo.name} ${clientInfo.surname} (${clientInfo.email})',
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text:
                  '? ${str.clientsDeleteClientConfirmationDialogInfoAboutAccessLoss}',
              style: textStyle,
            ),
          ],
        ),
      ),
      confirmButtonLabel: Str.of(context).delete,
      confirmButtonColor: Theme.of(context).colorScheme.error,
      displayConfirmationButtonAsFilled: true,
    );
  }
}
