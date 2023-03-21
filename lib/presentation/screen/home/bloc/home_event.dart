import 'package:equatable/equatable.dart';

import 'home_state.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
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
