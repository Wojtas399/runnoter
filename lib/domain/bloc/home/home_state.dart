part of 'home_bloc.dart';

class HomeState extends BlocState<HomeState> {
  final String? loggedUserName;
  final Settings? appSettings;

  const HomeState({
    required super.status,
    this.loggedUserName,
    this.appSettings,
  });

  @override
  List<Object?> get props => [
        status,
        loggedUserName,
        appSettings,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    String? loggedUserName,
    Settings? appSettings,
  }) {
    return HomeState(
      status: status ?? const BlocStatusComplete(),
      loggedUserName: loggedUserName ?? this.loggedUserName,
      appSettings: appSettings ?? this.appSettings,
    );
  }
}
