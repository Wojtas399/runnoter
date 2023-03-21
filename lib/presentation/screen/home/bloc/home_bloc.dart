import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../model/bloc_status.dart';
import '../../../model/bloc_with_status.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends BlocWithStatus<HomeEvent, HomeState, HomeInfo, dynamic> {
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
    on<HomeEventSignOut>(_signOut);
  }

  void _currentPageChanged(
    HomeEventCurrentPageChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      currentPage: event.currentPage,
    ));
  }

  void _signOut(
    HomeEventSignOut event,
    Emitter<HomeState> emit,
  ) {
    //TODO: call method to sign out user
    emitCompleteStatus(emit, HomeInfo.userSignedOut);
  }
}
