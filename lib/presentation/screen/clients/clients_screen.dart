import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/cubit/clients/clients_cubit.dart';
import '../../component/body/medium_body_component.dart';
import '../../component/card_body_component.dart';
import '../../component/cubit_with_status_listener_component.dart';
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
      create: (_) => ClientsCubit()..initialize(),
      child: const _CubitListener(
        child: _Content(),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<ClientsCubit, ClientsState, ClientsCubitInfo,
        ClientsCubitError>(
      onInfo: (ClientsCubitInfo info) => _manageInfo(context, info),
      onError: (ClientsCubitError error) => _manageError(context, error),
      onStateChanged: _manageState,
      child: child,
    );
  }

  void _manageInfo(BuildContext context, ClientsCubitInfo info) {
    final str = Str.of(context);
    switch (info) {
      case ClientsCubitInfo.requestAccepted:
        showSnackbarMessage(str.successfullyAcceptedRequest);
      case ClientsCubitInfo.requestDeleted:
        showSnackbarMessage(str.successfullyUndidRequest);
      case ClientsCubitInfo.clientDeleted:
        showSnackbarMessage(str.clientsSuccessfullyDeletedClient);
    }
  }

  void _manageError(BuildContext context, ClientsCubitError error) {
    final str = Str.of(context);
    switch (error) {
      case ClientsCubitError.personAlreadyHasCoach:
        showMessageDialog(
          title: str.clientsPersonAlreadyHasCoachDialogTitle,
          message: str.clientsPersonAlreadyHasCoachDialogMessage,
        );
      case ClientsCubitError.clientIsNoLongerClient:
        showMessageDialog(
          title: str.clientsClientIsNotClientAnymoreDialogTitle,
          message: str.clientsClientIsNotClientAnymoreDialogMessage,
        );
    }
  }

  void _manageState(ClientsState state) {
    if (state.selectedChatId != null) {
      navigateTo(ChatRoute(chatId: state.selectedChatId));
    }
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: context.read<ClientsCubit>().refreshClients,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: MediumBody(
          child: Padding(
            padding: context.isMobileSize
                ? const EdgeInsets.only(top: 8, bottom: 144)
                : const EdgeInsets.all(24),
            child: const ResponsiveLayout(
              mobileBody: _MobileContent(),
              desktopBody: _DesktopContent(),
            ),
          ),
        ),
      ),
    );
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
