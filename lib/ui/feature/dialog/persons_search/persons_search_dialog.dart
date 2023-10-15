import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../data/additional_model/coaching_request.dart';
import '../../../component/cubit_with_status_listener_component.dart';
import '../../../component/responsive_layout_component.dart';
import '../../../service/dialog_service.dart';
import '../../../service/navigator_service.dart';
import 'cubit/persons_search_cubit.dart';
import 'persons_search_found_perons.dart';
import 'persons_search_input.dart';

class PersonsSearchDialog extends StatelessWidget {
  final CoachingRequestDirection requestDirection;

  const PersonsSearchDialog({super.key, required this.requestDirection});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PersonsSearchCubit(
        requestDirection: requestDirection,
      )..initialize(),
      child: const _CubitListener(
        child: ResponsiveLayout(
          mobileBody: _FullScreenDialog(),
          desktopBody: _NormalDialog(),
        ),
      ),
    );
  }
}

class _CubitListener extends StatelessWidget {
  final Widget child;

  const _CubitListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return CubitWithStatusListener<PersonsSearchCubit, PersonsSearchState,
        PersonsSearchCubitInfo, PersonsSearchCubitError>(
      onInfo: (PersonsSearchCubitInfo info) => _manageInfo(context, info),
      onError: (PersonsSearchCubitError error) => _manageError(context, error),
      child: child,
    );
  }

  void _manageInfo(BuildContext context, PersonsSearchCubitInfo info) {
    switch (info) {
      case PersonsSearchCubitInfo.requestSent:
        popRoute();
        showSnackbarMessage(
          Str.of(context).personsSearchSuccessfullySentRequest,
        );
    }
  }

  Future<void> _manageError(
    BuildContext context,
    PersonsSearchCubitError error,
  ) async {
    switch (error) {
      case PersonsSearchCubitError.userAlreadyHasCoach:
        final bloc = context.read<PersonsSearchCubit>();
        await showMessageDialog(
          title: Str.of(context).personsSearchUserAlreadyHasCoachInfoTitle,
          message: Str.of(context).personsSearchUserAlreadyHasCoachInfoMessage,
        );
        bloc.search(bloc.state.searchQuery);
    }
  }
}

class _NormalDialog extends StatelessWidget {
  const _NormalDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const _DialogTitle(),
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
        title: const _DialogTitle(),
        leading: const CloseButton(),
      ),
      body: const SafeArea(
        child: _Content(),
      ),
    );
  }
}

class _DialogTitle extends StatelessWidget {
  const _DialogTitle();

  @override
  Widget build(BuildContext context) {
    final CoachingRequestDirection requestDirection =
        context.read<PersonsSearchCubit>().requestDirection;
    final str = Str.of(context);
    final String title = switch (requestDirection) {
      CoachingRequestDirection.clientToCoach => str.coachesSearchTitle,
      CoachingRequestDirection.coachToClient => str.usersSearchTitle,
    };

    return Text(title);
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
