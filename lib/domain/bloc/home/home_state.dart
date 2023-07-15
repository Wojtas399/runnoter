part of 'home_bloc.dart';

class HomeState extends BlocState<HomeState> {
  final String? loggedUserEmail;
  final String? loggedUserName;
  final String? loggedUserSurname;
  final ThemeMode? themeMode;
  final Language? language;
  final DistanceUnit? distanceUnit;
  final PaceUnit? paceUnit;

  const HomeState({
    required super.status,
    this.loggedUserEmail,
    this.loggedUserName,
    this.loggedUserSurname,
    this.themeMode,
    this.language,
    this.distanceUnit,
    this.paceUnit,
  });

  @override
  List<Object?> get props => [
        status,
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
        language,
        distanceUnit,
        paceUnit,
      ];

  bool get areAllDataLoaded =>
      loggedUserName != null &&
      loggedUserSurname != null &&
      loggedUserEmail != null &&
      themeMode != null &&
      language != null &&
      distanceUnit != null &&
      paceUnit != null;

  @override
  HomeState copyWith({
    BlocStatus? status,
    String? loggedUserEmail,
    String? loggedUserName,
    String? loggedUserSurname,
    ThemeMode? themeMode,
    Language? language,
    DistanceUnit? distanceUnit,
    PaceUnit? paceUnit,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      loggedUserEmail: loggedUserEmail ?? this.loggedUserEmail,
      loggedUserName: loggedUserName ?? this.loggedUserName,
      loggedUserSurname: loggedUserSurname ?? this.loggedUserSurname,
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      distanceUnit: distanceUnit ?? this.distanceUnit,
      paceUnit: paceUnit ?? this.paceUnit,
    );
  }
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
  final PaceUnit? paceUnit;

  const HomeStateListenedParams({
    required this.loggedUserEmail,
    required this.loggedUserName,
    required this.loggedUserSurname,
    required this.themeMode,
    required this.language,
    required this.distanceUnit,
    required this.paceUnit,
  });

  @override
  List<Object?> get props => [
        loggedUserEmail,
        loggedUserName,
        loggedUserSurname,
        themeMode,
        language,
        distanceUnit,
        paceUnit,
      ];
}
