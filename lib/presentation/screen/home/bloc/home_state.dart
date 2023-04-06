import '../../../../domain/model/settings.dart';
import '../../../model/bloc_state.dart';
import '../../../model/bloc_status.dart';

class HomeState extends BlocState<HomeState> {
  final HomePage currentPage;
  final String? loggedUserEmail;
  final String? loggedUserName;
  final String? loggedUserSurname;
  final ThemeMode? themeMode;
  final Language? language;

  const HomeState({
    required super.status,
    required this.currentPage,
    this.loggedUserEmail,
    this.loggedUserName,
    this.loggedUserSurname,
    this.themeMode,
    this.language,
  });

  @override
  List<Object?> get props => [
        status,
        currentPage,
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
        language,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    HomePage? currentPage,
    String? loggedUserEmail,
    String? loggedUserName,
    String? loggedUserSurname,
    ThemeMode? themeMode,
    Language? language,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      currentPage: currentPage ?? this.currentPage,
      loggedUserEmail: loggedUserEmail ?? this.loggedUserEmail,
      loggedUserName: loggedUserName ?? this.loggedUserName,
      loggedUserSurname: loggedUserSurname ?? this.loggedUserSurname,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
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
