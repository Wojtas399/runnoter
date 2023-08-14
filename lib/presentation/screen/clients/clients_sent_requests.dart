import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/gender_extensions.dart';
import '../../formatter/person_formatter.dart';
import '../../service/dialog_service.dart';

class ClientsSentRequests extends StatefulWidget {
  const ClientsSentRequests({super.key});

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<ClientsSentRequests> {
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
            child: TitleLarge(Str.of(context).clientsSentRequests),
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
    final List<SentCoachingRequest>? sentRequests = context.select(
      (ClientsBloc bloc) => bloc.state.sentRequests,
    );

    return switch (sentRequests) {
      null => const SizedBox(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      [] => Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BodyLarge(
                Str.of(context).clientsNoSentCoachingRequests,
                color: Theme.of(context).colorScheme.outline,
              ),
            ],
          ),
        ),
      [...] => ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: ListTile.divideTiles(
            context: context,
            tiles: sentRequests.map((request) => _SentRequestItem(request)),
          ).toList(),
        ),
    };
  }
}

class _SentRequestItem extends StatelessWidget {
  final SentCoachingRequest request;

  const _SentRequestItem(this.request);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.isMobileSize ? 8 : 0,
      ),
      title: Text(
        '${request.receiver.name} ${request.receiver.surname}',
      ),
      subtitle: Text(request.receiver.email),
      leading: Icon(request.receiver.gender.toIconData()),
      trailing: IconButton(
        onPressed: () => _onDeleteIconPressed(context),
        icon: Icon(
          Icons.delete_outline,
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );
  }

  Future<void> _onDeleteIconPressed(BuildContext context) async {
    final ClientsBloc bloc = context.read<ClientsBloc>();
    final bool isDeletionConfirmed =
        await _askForRequestDeletionConfirmation(context);
    if (isDeletionConfirmed) {
      bloc.add(ClientsEventDeleteRequest(requestId: request.requestId));
    }
  }

  Future<bool> _askForRequestDeletionConfirmation(
    BuildContext context,
  ) async {
    final Person receiverInfo = request.receiver;
    final TextStyle? textStyle = Theme.of(context).textTheme.bodyMedium;
    final str = Str.of(context);

    return askForConfirmation(
      title: Text(str.undoRequestConfirmationDialogTitle),
      content: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: str.undoRequestConfirmationDialogMessage,
              style: textStyle,
            ),
            TextSpan(
              text: receiverInfo.toFullNameWithEmail(),
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
