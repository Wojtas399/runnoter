part of 'home_screen.dart';

class _NavigationRail extends StatelessWidget {
  final int selectedIndex;
  final List<_Destination> destinations;
  final Function(int index) onDestinationSelected;

  const _NavigationRail({
    required this.selectedIndex,
    required this.destinations,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      labelType: NavigationRailLabelType.all,
      groupAlignment: -0.9,
      trailing: Column(
        children: [
          const SizedBox(height: 32),
          IconButton(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout_outlined),
          ),
          LabelMedium(Str.of(context).homeSignOut),
        ],
      ),
      destinations: destinations
          .map(
            (destination) => NavigationRailDestination(
              icon: Icon(destination.iconData),
              selectedIcon: Icon(destination.selectedIconData),
              label: Text(destination.label),
            ),
          )
          .toList(),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
    );
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
