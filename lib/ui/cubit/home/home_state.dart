part of 'home_cubit.dart';

class HomeState extends CubitState<HomeState> {
  final AccountType? accountType;
  final String? loggedUserName;
  final bool hasLoggedUserCoach;
  final UserSettings? userSettings;

  const HomeState({
    required super.status,
    this.accountType,
    this.loggedUserName,
    this.hasLoggedUserCoach = false,
    this.userSettings,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        loggedUserName,
        hasLoggedUserCoach,
        userSettings,
      ];

  @override
  HomeState copyWith({
    CubitStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    bool? hasLoggedUserCoach,
    UserSettings? userSettings,
  }) =>
      HomeState(
        status: status ?? const CubitStatusComplete(),
        accountType: accountType ?? this.accountType,
        loggedUserName: loggedUserName ?? this.loggedUserName,
        hasLoggedUserCoach: hasLoggedUserCoach ?? this.hasLoggedUserCoach,
        userSettings: userSettings ?? this.userSettings,
      );
}
