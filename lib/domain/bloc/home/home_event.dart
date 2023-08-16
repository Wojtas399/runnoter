part of 'home_bloc.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventDeleteCoachingRequest extends HomeEvent {
  final String requestId;

  const HomeEventDeleteCoachingRequest({required this.requestId});
}

class HomeEventSignOut extends HomeEvent {
  const HomeEventSignOut();
}
