import 'home_state.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventListenedParamsChanged extends HomeEvent {
  final HomeStateListenedParams? listenedParams;

  const HomeEventListenedParamsChanged({
    required this.listenedParams,
  });
}

class HomeEventDrawerPageChanged extends HomeEvent {
  final DrawerPage drawerPage;

  const HomeEventDrawerPageChanged({
    required this.drawerPage,
  });
}

class HomeEventBottomNavPageChanged extends HomeEvent {
  final BottomNavPage bottomNavPage;

  const HomeEventBottomNavPageChanged({
    required this.bottomNavPage,
  });
}

class HomeEventSignOut extends HomeEvent {
  const HomeEventSignOut();
}
