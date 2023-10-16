import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/model/person.dart';
import '../../../component/empty_content_info_component.dart';
import '../../../component/gap/gap_components.dart';
import '../../../component/gap/gap_horizontal_components.dart';
import '../../../component/loading_info_component.dart';
import '../../../component/text/title_text_components.dart';
import '../../../config/navigation/router.dart';
import '../../../cubit/clients/clients_cubit.dart';
import '../../../cubit/notifications/notifications_cubit.dart';
import '../../../extension/context_extensions.dart';
import '../../../extension/widgets_list_extensions.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';

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
      (ClientsCubit cubit) => cubit.state.clients,
    );
    final List<String>? idsOfClientsWithAwaitingMessages = context.select(
      (NotificationsCubit cubit) =>
          cubit.state.idsOfClientsWithAwaitingMessages,
    );

    return switch (clients) {
      null => const LoadingInfo(),
      [] => EmptyContentInfo(
          title: Str.of(context).clientsNoClientsTitle,
          subtitle: Str.of(context).clientsNoClientsMessage,
        ),
      [...] => Column(
          children: ListTile.divideTiles(
            context: context,
            tiles: clients.map(
              (Person client) => _ClientItem(
                clientInfo: client,
                showMessageBadge:
                    idsOfClientsWithAwaitingMessages?.contains(client.id) ==
                        true,
              ),
            ),
          ).toList(),
        ),
    };
  }
}

class _ClientItem extends StatelessWidget {
  final Person clientInfo;
  final bool showMessageBadge;

  const _ClientItem({required this.clientInfo, required this.showMessageBadge});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('${clientInfo.name} ${clientInfo.surname}'),
      subtitle: Text(clientInfo.email),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.isMobileSize ? 8 : 0,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            onPressed: () => _onOpenChat(context),
            icon: Badge(
              isLabelVisible: showMessageBadge,
              child: const Icon(Icons.message_outlined),
            ),
          ),
          IconButton(
            onPressed: () => _onShowProfile(context),
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

  Future<void> _onOpenChat(BuildContext context) async {
    final ClientsCubit cubit = context.read<ClientsCubit>();
    final bool isClientStillClient =
        await cubit.checkIfClientIsStillClient(clientInfo.id);
    if (isClientStillClient) cubit.openChatWithClient(clientInfo.id);
  }

  Future<void> _onShowProfile(BuildContext context) async {
    final bool isClientStillClient = await context
        .read<ClientsCubit>()
        .checkIfClientIsStillClient(clientInfo.id);
    if (isClientStillClient) navigateTo(ClientRoute(clientId: clientInfo.id));
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
