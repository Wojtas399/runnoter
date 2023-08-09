import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/clients_search/clients_search_bloc.dart';
import '../../component/responsive_layout_component.dart';
import 'clients_search_found_users.dart';
import 'clients_search_input.dart';

class ClientsSearchDialog extends StatelessWidget {
  const ClientsSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ClientsSearchBloc(),
      child: const ResponsiveLayout(
        mobileBody: _FullScreenDialog(),
        desktopBody: _NormalDialog(),
      ),
    );
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Text('Search for clients'),
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
          child: ClientsSearchInput(),
        ),
        Expanded(
          child: ClientsSearchFoundUsers(),
        ),
      ],
    );
  }
}
