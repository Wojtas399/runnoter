part of 'home_cubit.dart';

class HomeState extends CubitState<HomeState> {
  final AccountType? accountType;
  final String? loggedUserName;
  final UserSettings? userSettings;

  const HomeState({
    required super.status,
    this.accountType,
    this.loggedUserName,
    this.userSettings,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        loggedUserName,
        userSettings,
      ];

  @override
  HomeState copyWith({
    CubitStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    UserSettings? userSettings,
  }) =>
      HomeState(
        status: status ?? const CubitStatusComplete(),
        accountType: accountType ?? this.accountType,
        loggedUserName: loggedUserName ?? this.loggedUserName,
        userSettings: userSettings ?? this.userSettings,
      );
}
