import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/clients/clients_cubit.dart';
import '../../../domain/entity/person.dart';
import '../../component/empty_content_info_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/gap/gap_horizontal_components.dart';
import '../../component/loading_info_component.dart';
import '../../component/text/title_text_components.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../extension/widgets_list_extensions.dart';
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
      (ClientsCubit cubit) => cubit.state.clients,
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
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.isMobileSize ? 16 : 0,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () =>
                context.read<ClientsCubit>().openChatWithClient(clientInfo.id),
            icon: const Icon(Icons.message_outlined),
          ),
          IconButton(
            onPressed: _onShowProfile,
            icon: const Icon(Icons.assignment_ind_outlined),
          ),
          IconButton(
            onPressed: () => _onDeleteClient(context),
            icon: const Icon(Icons.person_remove_outlined),
          ),
        ].addSeparator(
          !context.isMobileSize ? const GapHorizontal8() : const SizedBox(),
        ),
      ),
    );
  }

  void _onShowProfile() {
    navigateTo(ClientRoute(clientId: clientInfo.id));
  }

  Future<void> _onDeleteClient(BuildContext context) async {
    final ClientsCubit cubit = context.read<ClientsCubit>();
    final bool isDeletionConfirmed =
        await _askForClientDeletionConfirmation(context);
    if (isDeletionConfirmed) cubit.deleteClient(clientInfo.id);
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
