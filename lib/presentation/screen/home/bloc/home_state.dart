import 'package:equatable/equatable.dart';

import '../../../../domain/additional_model/bloc_state.dart';
import '../../../../domain/additional_model/bloc_status.dart';
import '../../../../domain/entity/settings.dart';

class HomeState extends BlocState<HomeState> {
  final DrawerPage drawerPage;
  final BottomNavPage bottomNavPage;
  final String? loggedUserEmail;
  final String? loggedUserName;
  final String? loggedUserSurname;
  final ThemeMode? themeMode;
  final Language? language;

  const HomeState({
    required super.status,
    required this.drawerPage,
    required this.bottomNavPage,
    this.loggedUserEmail,
    this.loggedUserName,
    this.loggedUserSurname,
    this.themeMode,
    this.language,
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
      ];

  bool get areAllDataLoaded =>
      loggedUserName != null &&
      loggedUserSurname != null &&
      loggedUserEmail != null &&
      themeMode != null &&
      language != null;

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
    );
  }
}

enum DrawerPage {
  home(0),
  profile(1),
  mileage(2),
  blood(3),
  tournaments(4),
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

  const HomeStateListenedParams({
    required this.loggedUserEmail,
    required this.loggedUserName,
    required this.loggedUserSurname,
    required this.themeMode,
    required this.language,
  });

  @override
  List<Object?> get props => [
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
        language,
      ];
}
