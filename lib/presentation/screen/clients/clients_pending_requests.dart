import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/gender_extensions.dart';
import '../../service/dialog_service.dart';

class ClientsPendingRequests extends StatefulWidget {
  const ClientsPendingRequests({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientsPendingRequests> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: const EdgeInsets.all(0),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _isExpanded = !isExpanded;
        });
      },
      children: [
        ExpansionPanel(
          backgroundColor: Colors.transparent,
          isExpanded: _isExpanded,
          headerBuilder: (_, isExpanded) => Padding(
            padding: EdgeInsets.only(
              left: context.isMobileSize ? 24 : 0,
              right: context.isMobileSize ? 16 : 0,
              top: 8,
            ),
            child: TitleLarge(Str.of(context).clientsPendingRequests),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobileSize ? 16 : 0,
            ),
            child: const _Content(),
          ),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    final List<InvitedPerson>? invitedPersons = context.select(
      (ClientsBloc bloc) => bloc.state.invitedPersons,
    );

    return switch (invitedPersons) {
      null => const SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      [] => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BodyLarge(
              Str.of(context).clientsNoSentCoachingRequests,
              color: Theme.of(context).colorScheme.outline,
            ),
          ],
        ),
      [...] => ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: ListTile.divideTiles(
            context: context,
            tiles: invitedPersons.map((person) => _InvitedPersonItem(person)),
          ).toList(),
        ),
    };
  }
}

class _InvitedPersonItem extends StatelessWidget {
  final InvitedPerson invitedPerson;

  const _InvitedPersonItem(this.invitedPerson);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      title: Text(
        '${invitedPerson.person.name} ${invitedPerson.person.surname}',
      ),
      subtitle: Text(invitedPerson.person.email),
      leading: Icon(invitedPerson.person.gender.toIconData()),
      trailing: IconButton(
        onPressed: () => _onDeleteIconPressed(context),
        icon: const Icon(Icons.delete_outline),
      ),
    );
  }

  Future<void> _onDeleteIconPressed(BuildContext context) async {
    final bool isDeletionConfirmed =
        await _askForRequestDeletionConfirmation(context);
    if (isDeletionConfirmed) {
      //TODO
    }
  }

  Future<bool> _askForRequestDeletionConfirmation(
    BuildContext context,
  ) async {
    final Person personInfo = invitedPerson.person;
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final str = Str.of(context);

    return askForConfirmation(
      title: Text(str.clientsUndoRequestConfirmationDialogTitle),
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str.clientsUndoRequestConfirmationDialogMessage,
              style: textStyle,
            ),
            TextSpan(
              text:
                  '${personInfo.name} ${personInfo.surname} (${personInfo.email})',
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      confirmButtonLabel: str.undo,
      displaySubmitButtonAsFilled: true,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
