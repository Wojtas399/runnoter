import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients/clients_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/gap/gap_components.dart';
import '../../component/responsive_layout_component.dart';
import '../../config/navigation/router.dart';
import '../../extension/context_extensions.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'clients_list.dart';
import 'clients_requests.dart';

@RoutePage()
class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsBloc()..add(const ClientsEventInitialize()),
      child: _BlocListener(
        child: SingleChildScrollView(
          child: MediumBody(
            child: Padding(
              padding: context.isMobileSize
                  ? const EdgeInsets.only(top: 8, bottom: 24)
                  : const EdgeInsets.all(24),
              child: const ResponsiveLayout(
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
      onStateChanged: _manageState,
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ClientsBlocInfo info) {
    final str = Str.of(context);
    switch (info) {
      case ClientsBlocInfo.requestAccepted:
        showSnackbarMessage(str.successfullyAcceptedRequest);
      case ClientsBlocInfo.requestDeleted:
        showSnackbarMessage(str.successfullyUndidRequest);
        break;
      case ClientsBlocInfo.clientDeleted:
        showSnackbarMessage(str.clientsSuccessfullyDeletedClient);
        break;
    }
  }

  void _manageState(ClientsState state) {
    if (state.selectedChatId != null) {
      navigateTo(ChatRoute(chatId: state.selectedChatId));
    }
  }
}

class _MobileContent extends StatelessWidget {
  const _MobileContent();

  @override
  Widget build(BuildContext context) {
    const divider = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Divider(),
    );

    return const Column(
      children: [
        ClientsSentRequests(),
        divider,
        ClientsReceivedRequests(),
        divider,
        Gap8(),
        ClientsList(),
      ],
    );
  }
}

class _DesktopContent extends StatelessWidget {
  const _DesktopContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        CardBody(
          child: ClientsSentRequests(),
        ),
        Gap16(),
        CardBody(
          child: ClientsReceivedRequests(),
        ),
        Gap16(),
        CardBody(
          child: ClientsList(),
        ),
      ],
    );
  }
}
