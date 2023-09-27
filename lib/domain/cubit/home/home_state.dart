part of 'home_cubit.dart';

class HomeState extends CubitState<HomeState> {
  final AccountType? accountType;
  final String? loggedUserName;
  final Settings? appSettings;

  const HomeState({
    required super.status,
    this.accountType,
    this.loggedUserName,
    this.appSettings,
  });

  @override
  List<Object?> get props => [status, accountType, loggedUserName, appSettings];

  @override
  HomeState copyWith({
    CubitStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    Settings? appSettings,
  }) =>
      HomeState(
        status: status ?? const CubitStatusComplete(),
        accountType: accountType ?? this.accountType,
        loggedUserName: loggedUserName ?? this.loggedUserName,
        appSettings: appSettings ?? this.appSettings,
      );
}
