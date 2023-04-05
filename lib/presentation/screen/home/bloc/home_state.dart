import '../../../../domain/model/settings.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class HomeState extends BlocState<HomeState> {
  final HomePage currentPage;
  final String? loggedUserEmail;
  final String? loggedUserName;
  final String? loggedUserSurname;
  final ThemeMode? themeMode;

  const HomeState({
    required super.status,
    required this.currentPage,
    this.loggedUserEmail,
    this.loggedUserName,
    this.loggedUserSurname,
    this.themeMode,
  });

  @override
  List<Object?> get props => [
        status,
        currentPage,
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    HomePage? currentPage,
    String? loggedUserEmail,
    String? loggedUserName,
    String? loggedUserSurname,
    ThemeMode? themeMode,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      currentPage: currentPage ?? this.currentPage,
      loggedUserEmail: loggedUserEmail ?? this.loggedUserEmail,
      loggedUserName: loggedUserName ?? this.loggedUserName,
      loggedUserSurname: loggedUserSurname ?? this.loggedUserSurname,
      themeMode: themeMode ?? this.themeMode,
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
