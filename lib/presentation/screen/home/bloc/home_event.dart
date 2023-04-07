import 'package:equatable/equatable.dart';

import 'home_state.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventListenedParamsChanged extends HomeEvent {
  final HomeStateListenedParams? listenedParams;

  const HomeEventListenedParamsChanged({
    required this.listenedParams,
  });

  @override
  List<Object?> get props => [
        listenedParams,
      ];
}

class HomeEventCurrentPageChanged extends HomeEvent {
  final HomePage currentPage;

  const HomeEventCurrentPageChanged({
    required this.currentPage,
  });

  @override
  List<Object> get props => [
        currentPage,
      ];
}

class HomeEventSignOut extends HomeEvent {
  const HomeEventSignOut();
}
