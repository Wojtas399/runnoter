part of 'home_bloc.dart';

class HomeState extends BlocState<HomeState> {
  final DrawerPage drawerPage;
  final BottomNavPage bottomNavPage;
  final String? loggedUserEmail;
  final String? loggedUserName;
  final String? loggedUserSurname;
  final ThemeMode? themeMode;
  final Language? language;
  final DistanceUnit? distanceUnit;

  const HomeState({
    required super.status,
    required this.drawerPage,
    required this.bottomNavPage,
    this.loggedUserEmail,
    this.loggedUserName,
    this.loggedUserSurname,
    this.themeMode,
    this.language,
    this.distanceUnit,
  });

  @override
  List<Object?> get props => [
        status,
        drawerPage,
        bottomNavPage,
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
        language,
        distanceUnit,
      ];

  bool get areAllDataLoaded =>
      loggedUserName != null &&
      loggedUserSurname != null &&
      loggedUserEmail != null &&
      themeMode != null &&
      language != null &&
      distanceUnit != null;

  @override
  HomeState copyWith({
    BlocStatus? status,
    DrawerPage? drawerPage,
    BottomNavPage? bottomNavPage,
    String? loggedUserEmail,
    String? loggedUserName,
    String? loggedUserSurname,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      drawerPage: drawerPage ?? this.drawerPage,
      bottomNavPage: bottomNavPage ?? this.bottomNavPage,
      loggedUserEmail: loggedUserEmail ?? this.loggedUserEmail,
      loggedUserName: loggedUserName ?? this.loggedUserName,
      loggedUserSurname: loggedUserSurname ?? this.loggedUserSurname,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      distanceUnit: distanceUnit ?? this.distanceUnit,
    );
  }
}

enum DrawerPage {
  home(0),
  profile(1),
  mileage(2),
  blood(3),
  competitions(4),
  signOut(5);

  final int pageIndex;

  const DrawerPage(this.pageIndex);
}

enum BottomNavPage {
  currentWeek(0),
  calendar(1),
  pulseAndWeight(2);

  final int pageIndex;

  const BottomNavPage(this.pageIndex);
}

enum HomeInfo {
  userSignedOut,
}

class HomeStateListenedParams extends Equatable {
  final String? loggedUserEmail;
  final String? loggedUserName;
  final String? loggedUserSurname;
  final ThemeMode? themeMode;
  final Language? language;
  final DistanceUnit? distanceUnit;

  const HomeStateListenedParams({
    required this.loggedUserEmail,
    required this.loggedUserName,
    required this.loggedUserSurname,
    required this.themeMode,
    required this.language,
    required this.distanceUnit,
  });

  @override
  List<Object?> get props => [
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
        language,
        distanceUnit,
      ];
}
