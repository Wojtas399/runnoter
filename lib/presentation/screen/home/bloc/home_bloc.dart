import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends BlocWithStatus<HomeEvent, HomeState, dynamic, dynamic> {
  HomeBloc({
    BlocStatus status = const BlocStatusInitial(),
    HomePage currentPage = HomePage.currentWeek,
  }) : super(
          HomeState(
            status: status,
            currentPage: currentPage,
          ),
        ) {
    on<HomeEventCurrentPageChanged>(_currentPageChanged);
  }

  void _currentPageChanged(
    HomeEventCurrentPageChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      currentPage: event.currentPage,
    ));
  }
}
