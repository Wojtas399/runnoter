import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/users_search/users_search_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'users_search_found_users.dart';
import 'users_search_input.dart';

class UsersSearchDialog extends StatelessWidget {
  const UsersSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UsersSearchBloc()..add(const UsersSearchEventInitialize()),
      child: const _BlocListener(
        child: ResponsiveLayout(
          mobileBody: _FullScreenDialog(),
          desktopBody: _NormalDialog(),
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
    return BlocWithStatusListener<UsersSearchBloc, UsersSearchState,
        UsersSearchBlocInfo, dynamic>(
      onInfo: (UsersSearchBlocInfo info) => _manageInfo(context, info),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, UsersSearchBlocInfo info) {
    switch (info) {
      case UsersSearchBlocInfo.invitationSent:
        showSnackbarMessage(
          Str.of(context).usersSearchSuccessfullySentInvitation,
        );
        break;
    }
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).usersSearchTitle),
      content: const SizedBox(
        width: 500,
        height: 500,
        child: _Content(),
      ),
      actions: [
        TextButton(
          onPressed: popRoute,
          child: Text(Str.of(context).close),
        ),
      ],
    );
  }
}

class _FullScreenDialog extends StatelessWidget {
  const _FullScreenDialog();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Str.of(context).usersSearchTitle),
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: _Content(),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.all(16),
          child: UsersSearchInput(),
        ),
        Expanded(
          child: UsersSearchFoundUsers(),
        ),
      ],
    );
  }
}
