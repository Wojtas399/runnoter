part of 'home_screen.dart';

class _NavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final List<_Destination> destinations;
  final Function(int index) onDestinationSelected;

  const _NavigationDrawer({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
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
      selectedIndex: selectedIndex,
      surfaceTintColor: MediaQuery.of(context).size.width > maxTabletWidth
          ? Theme.of(context).colorScheme.background
          : null,
      onDestinationSelected: (int index) {
        _onDestinationSelected(context, index);
      },
      children: [
        const SizedBox(height: 16),
        const _AppLogo(),
        divider,
        const _UserInfo(),
        ...destinations.map(
          (destination) => NavigationDrawerDestination(
            icon: Icon(destination.iconData),
            selectedIcon: Icon(destination.selectedIconData),
            label: Text(destination.label),
          ),
        ),
        divider,
        NavigationDrawerDestination(
          icon: const Icon(Icons.logout_outlined),
          label: Text(Str.of(context).homeSignOut),
        ),
      ],
    );
  }

  Future<void> _onDestinationSelected(
    BuildContext context,
    int destinationIndex,
  ) async {
    if (destinationIndex == destinations.length) {
      await _signOut(context);
    } else {
      onDestinationSelected(destinationIndex);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    final HomeBloc bloc = context.read<HomeBloc>();
    final str = Str.of(context);
    final bool confirmed = await askForConfirmation(
      title: str.homeSignOutConfirmationDialogTitle,
      message: str.homeSignOutConfirmationDialogMessage,
      confirmButtonLabel: str.homeSignOut,
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
