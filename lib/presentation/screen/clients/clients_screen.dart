import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../component/big_button_component.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../dialog/persons_search/persons_search_dialog.dart';
import '../../service/dialog_service.dart';
import 'clients_list.dart';
import 'clients_sent_requests.dart';

@RoutePage()
class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsBloc()..add(const ClientsEventInitialize()),
      child: const _BlocListener(
        child: SingleChildScrollView(
          child: MediumBody(
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 24),
              child: ResponsiveLayout(
                mobileBody: _MobileContent(),
                desktopBody: _DesktopContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BlocListener extends StatelessWidget {
  final Widget child;

  const _BlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocWithStatusListener<ClientsBloc, ClientsState, ClientsBlocInfo,
        dynamic>(
      onInfo: (ClientsBlocInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ClientsBlocInfo info) {
    switch (info) {
      case ClientsBlocInfo.requestDeleted:
        showSnackbarMessage(Str.of(context).clientsSuccessfullyUndidRequest);
        break;
    }
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ClientsSentRequests(),
        Gap24(),
        ClientsList(),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BigButton(
          label: Str.of(context).clientsSearchUsers,
          onPressed: () => showDialogDependingOnScreenSize(
            const PersonsSearchDialog(),
          ),
        ),
        const Gap32(),
        const Column(
          children: [
            CardBody(
              child: ClientsSentRequests(),
            ),
            Gap16(),
            CardBody(
              child: ClientsList(),
            ),
          ],
        ),
      ],
    );
  }
}
