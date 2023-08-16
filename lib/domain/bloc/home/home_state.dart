part of 'home_bloc.dart';

class HomeState extends BlocState<HomeState> {
  final AccountType? accountType;
  final String? loggedUserName;
  final Settings? appSettings;
  final List<Person> newClients;
  final Person? newCoach;

  const HomeState({
    required super.status,
    this.accountType,
    this.loggedUserName,
    this.appSettings,
    this.newClients = const [],
    this.newCoach,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        loggedUserName,
        appSettings,
        newClients,
        newCoach,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    Settings? appSettings,
    List<Person>? newClients,
    Person? newCoach,
  }) =>
      HomeState(
        status: status ?? const BlocStatusComplete(),
        accountType: accountType ?? this.accountType,
        loggedUserName: loggedUserName ?? this.loggedUserName,
        appSettings: appSettings ?? this.appSettings,
        newClients: newClients ?? this.newClients,
        newCoach: newCoach,
      );
}
