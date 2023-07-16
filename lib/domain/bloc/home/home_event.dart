part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventSignOut extends HomeEvent {
  const HomeEventSignOut();
}
