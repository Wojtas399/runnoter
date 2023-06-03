import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../service/dialog_service.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

class HomeDrawer extends StatelessWidget {
  final DrawerPage drawerPage;

  const HomeDrawer({
    super.key,
    required this.drawerPage,
  });

  @override
  Widget build(BuildContext context) {
    const Widget divider = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Divider(),
    );

    return NavigationDrawer(
      selectedIndex: drawerPage.index,
      onDestinationSelected: (int destinationIndex) {
        _onDestinationSelected(context, destinationIndex);
      },
      children: [
        const SizedBox(height: 16),
        const _AppLogo(),
        divider,
        const _UserInfo(),
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: Text(Str.of(context).homeDrawerHome),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.account_circle_outlined),
          selectedIcon: const Icon(Icons.account_circle),
          label: Text(Str.of(context).homeDrawerProfile),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.insert_chart_outlined),
          selectedIcon: const Icon(Icons.insert_chart),
          label: Text(Str.of(context).homeDrawerMileage),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.water_drop_outlined),
          selectedIcon: const Icon(Icons.water_drop),
          label: Text(Str.of(context).homeDrawerBloodTests),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.emoji_events_outlined),
          selectedIcon: const Icon(Icons.emoji_events),
          label: Text(Str.of(context).homeDrawerCompetitions),
        ),
        divider,
        NavigationDrawerDestination(
          icon: const Icon(Icons.logout_outlined),
          label: Text(Str.of(context).homeDrawerSignOut),
        ),
      ],
    );
  }

  Future<void> _onDestinationSelected(
    BuildContext context,
    int destinationIndex,
  ) async {
    final DrawerPage page = DrawerPage.values[destinationIndex];
    if (page == DrawerPage.signOut) {
      await _signOut(context);
    } else {
      context.read<HomeBloc>().add(
            HomeEventDrawerPageChanged(drawerPage: page),
          );
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final HomeBloc bloc = context.read<HomeBloc>();
    final bool confirmed = await askForConfirmation(
      context: context,
      title: Str.of(context).homeSignOutConfirmationDialogTitle,
      message: Str.of(context).homeSignOutConfirmationDialogMessage,
      confirmButtonLabel: Str.of(context).homeDrawerSignOut,
    );
    if (confirmed == true) {
      bloc.add(
        const HomeEventSignOut(),
      );
    }
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LoggedUserFullName(),
          SizedBox(height: 4),
          _LoggedUserEmail(),
        ],
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Image.asset('assets/logo.png'),
    );
  }
}

class _LoggedUserFullName extends StatelessWidget {
  const _LoggedUserFullName();

  @override
  Widget build(BuildContext context) {
    final String? name = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserName,
    );
    final String? surname = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserSurname,
    );

    return Text(
      '${name ?? ''} ${surname ?? ''}',
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class _LoggedUserEmail extends StatelessWidget {
  const _LoggedUserEmail();

  @override
  Widget build(BuildContext context) {
    final String? email = context.select(
      (HomeBloc bloc) => bloc.state.loggedUserEmail,
    );

    return Text(email ?? '');
  }
}
