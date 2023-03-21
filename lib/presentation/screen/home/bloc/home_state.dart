import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class HomeState extends BlocState<HomeState> {
  final HomePage currentPage;
  final String? loggedUserEmail;

  const HomeState({
    required super.status,
    required this.currentPage,
    this.loggedUserEmail,
  });

  @override
  List<Object?> get props => [
        status,
        currentPage,
        loggedUserEmail,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    HomePage? currentPage,
    String? loggedUserEmail,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      currentPage: currentPage ?? this.currentPage,
      loggedUserEmail: loggedUserEmail ?? this.loggedUserEmail,
    );
  }
}

enum HomePage {
  currentWeek(0),
  calendar(1),
  pulseAndWeight(2);

  final int pageIndex;

  const HomePage(this.pageIndex);
}

enum HomeInfo {
  userSignedOut,
}
