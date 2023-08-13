part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventDeleteAcceptedCoachingRequests extends HomeEvent {
  const HomeEventDeleteAcceptedCoachingRequests();
}

class HomeEventSignOut extends HomeEvent {
  const HomeEventSignOut();
}
