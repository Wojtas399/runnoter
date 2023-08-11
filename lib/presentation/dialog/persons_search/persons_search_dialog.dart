import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../domain/bloc/persons_search/persons_search_bloc.dart';
import '../../component/bloc_with_status_listener_component.dart';
import '../../component/responsive_layout_component.dart';
import '../../service/dialog_service.dart';
import '../../service/navigator_service.dart';
import 'persons_search_found_perons.dart';
import 'persons_search_input.dart';

class PersonsSearchDialog extends StatelessWidget {
  const PersonsSearchDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PersonsSearchBloc()..add(const PersonsSearchEventInitialize()),
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
    return BlocWithStatusListener<PersonsSearchBloc, PersonsSearchState,
        PersonsSearchBlocInfo, PersonsSearchBlocError>(
      onInfo: (PersonsSearchBlocInfo info) => _manageInfo(context, info),
      onError: (PersonsSearchBlocError error) => _manageError(context, error),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, PersonsSearchBlocInfo info) {
    switch (info) {
      case PersonsSearchBlocInfo.requestSent:
        showSnackbarMessage(
          Str.of(context).personsSearchSuccessfullySentInvitation,
        );
        break;
    }
  }

  Future<void> _manageError(
    BuildContext context,
    PersonsSearchBlocError error,
  ) async {
    switch (error) {
      case PersonsSearchBlocError.userAlreadyHasCoach:
        final bloc = context.read<PersonsSearchBloc>();
        await showMessageDialog(
          title: Str.of(context).personsSearchUserAlreadyHasCoachInfoTitle,
          message: Str.of(context).personsSearchUserAlreadyHasCoachInfoMessage,
        );
        bloc.add(PersonsSearchEventSearch(searchQuery: bloc.state.searchQuery));
        break;
    }
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Str.of(context).personsSearchTitle),
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
        title: Text(Str.of(context).personsSearchTitle),
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
          child: PersonsSearchInput(),
        ),
        Expanded(
          child: PersonsSearchFoundPersons(),
        ),
      ],
    );
  }
}