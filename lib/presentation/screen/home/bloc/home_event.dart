import 'package:equatable/equatable.dart';

import '../../../../domain/model/user.dart';
import 'home_state.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class HomeEventInitialize extends HomeEvent {
  const HomeEventInitialize();
}

class HomeEventLoggedUserEmailChanged extends HomeEvent {
  final String? loggedUserEmail;

  const HomeEventLoggedUserEmailChanged({
    required this.loggedUserEmail,
  });

  @override
  List<Object?> get props => [
        loggedUserEmail,
      ];
}

class HomeEventLoggedUserDataChanged extends HomeEvent {
  final User? loggedUserData;

  const HomeEventLoggedUserDataChanged({
    required this.loggedUserData,
  });

  @override
  List<Object?> get props => [
        loggedUserData,
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
