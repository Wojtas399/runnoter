part of 'home_bloc.dart';

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

class HomeEventSignOut extends HomeEvent {
  const HomeEventSignOut();
}
