import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/additional_model/coaching_request_short.dart';
import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../../domain/entity/person.dart';
import '../../component/text/body_text_components.dart';
import '../../component/text/title_text_components.dart';
import '../../extension/context_extensions.dart';
import '../../extension/gender_extensions.dart';
import '../../formatter/person_formatter.dart';
import '../../service/dialog_service.dart';

class ClientsSentRequests extends StatelessWidget {
  const ClientsSentRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestShort>? requests = context.select(
      (ClientsBloc bloc) => bloc.state.sentRequests,
    );

    return _RequestsList(
      requests: requests,
      requestDirection: CoachingRequestDirection.coachToClient,
    );
  }
}

class ClientsReceivedRequests extends StatelessWidget {
  const ClientsReceivedRequests({super.key});

  @override
  Widget build(BuildContext context) {
    final List<CoachingRequestShort>? requests = context.select(
      (ClientsBloc bloc) => bloc.state.receivedRequests,
    );

    return _RequestsList(
      requests: requests,
      requestDirection: CoachingRequestDirection.clientToCoach,
    );
  }
}

class _RequestsList extends StatefulWidget {
  final List<CoachingRequestShort>? requests;
  final CoachingRequestDirection requestDirection;

  const _RequestsList({
    required this.requests,
    required this.requestDirection,
  });

  @override
  State<StatefulWidget> createState() => _RequestsListState();
}

class _RequestsListState extends State<_RequestsList> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return ExpansionPanelList(
      elevation: 0,
      expandedHeaderPadding: const EdgeInsets.all(0),
      expansionCallback: (int index, _) {
        setState(() {
          _isExpanded = !_isExpanded;
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
            child: TitleLarge(
              switch (widget.requestDirection) {
                CoachingRequestDirection.coachToClient => str.sentRequests,
                CoachingRequestDirection.clientToCoach => str.receivedRequests,
              },
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobileSize ? 16 : 0,
            ),
            child: _RequestsListContent(
              requests: widget.requests,
              requestDirection: widget.requestDirection,
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestsListContent extends StatelessWidget {
  final List<CoachingRequestShort>? requests;
  final CoachingRequestDirection requestDirection;

  const _RequestsListContent({
    required this.requests,
    required this.requestDirection,
  });

  @override
  Widget build(BuildContext context) {
    final str = Str.of(context);

    return switch (requests) {
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
                switch (requestDirection) {
                  CoachingRequestDirection.coachToClient => str.noSentRequests,
                  CoachingRequestDirection.clientToCoach =>
                    str.noReceivedRequests,
                },
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
            tiles: requests!.map(
              (request) => _RequestItem(request, requestDirection),
            ),
          ).toList(),
        ),
    };
  }
}

class _RequestItem extends StatelessWidget {
  final CoachingRequestShort request;
  final CoachingRequestDirection requestDirection;

  const _RequestItem(this.request, this.requestDirection);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.isMobileSize ? 8 : 0,
      ),
      title: Text(request.personToDisplay.toFullName()),
      subtitle: Text(request.personToDisplay.email),
      leading: Icon(request.personToDisplay.gender.toIconData()),
      trailing: switch (requestDirection) {
        CoachingRequestDirection.coachToClient => IconButton(
            onPressed: () => _onDelete(context),
            icon: Icon(
              Icons.delete_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        CoachingRequestDirection.clientToCoach => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () => _onAccept(context),
                icon: Icon(
                  Icons.check,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              IconButton(
                onPressed: () => _onDelete(context),
                icon: Icon(
                  Icons.close,
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ),
      },
    );
  }

  void _onAccept(BuildContext context) {
    context.read<ClientsBloc>().add(
          ClientsEventAcceptRequest(requestId: request.id),
        );
  }

  Future<void> _onDelete(BuildContext context) async {
    final ClientsBloc bloc = context.read<ClientsBloc>();
    bool isDeletionConfirmed = true;
    if (requestDirection == CoachingRequestDirection.coachToClient) {
      isDeletionConfirmed = await _askForRequestDeletionConfirmation(context);
    }
    if (isDeletionConfirmed) {
      bloc.add(ClientsEventDeleteRequest(requestId: request.id));
    }
  }

  Future<bool> _askForRequestDeletionConfirmation(
    BuildContext context,
  ) async {
    final Person receiver = request.personToDisplay;
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
              text: receiver.toFullNameWithEmail(),
              style: textStyle?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      confirmButtonLabel: str.undo,
      displayConfirmationButtonAsFilled: true,
      confirmButtonColor: Theme.of(context).colorScheme.error,
    );
  }
}
