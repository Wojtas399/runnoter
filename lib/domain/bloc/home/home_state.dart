part of 'home_bloc.dart';

class HomeState extends BlocState<HomeState> {
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
  List<Object?> get props => [
        status,
        accountType,
        loggedUserName,
        appSettings,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    Settings? appSettings,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      accountType: accountType ?? this.accountType,
      loggedUserName: loggedUserName ?? this.loggedUserName,
      appSettings: appSettings ?? this.appSettings,
    );
  }
}
