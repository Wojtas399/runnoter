import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

enum HomePage {
  currentWeek(0),
  calendar(1),
  pulseAndWeight(2);

  final int pageIndex;

  const HomePage(this.pageIndex);
}

class HomeState extends BlocState<HomeState> {
  final HomePage currentPage;

  const HomeState({
    required super.status,
    required this.currentPage,
  });

  @override
  List<Object> get props => [
        status,
        currentPage,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    HomePage? currentPage,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      currentPage: currentPage ?? this.currentPage,
    );
  }
}
