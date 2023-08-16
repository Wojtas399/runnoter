part of 'home_bloc.dart';

class HomeState extends BlocState<HomeState> {
  final AccountType? accountType;
  final String? loggedUserName;
  final Settings? appSettings;
  final List<CoachingRequestShort> acceptedClientRequests;
  final CoachingRequestShort? acceptedCoachRequest;

  const HomeState({
    required super.status,
    this.accountType,
    this.loggedUserName,
    this.appSettings,
    this.acceptedClientRequests = const [],
    this.acceptedCoachRequest,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        loggedUserName,
        appSettings,
        acceptedClientRequests,
        acceptedCoachRequest,
      ];

  @override
  HomeState copyWith({
    BlocStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    Settings? appSettings,
    List<CoachingRequestShort>? acceptedClientRequests,
    CoachingRequestShort? acceptedCoachRequest,
  }) =>
      HomeState(
        status: status ?? const BlocStatusComplete(),
        accountType: accountType ?? this.accountType,
        loggedUserName: loggedUserName ?? this.loggedUserName,
        appSettings: appSettings ?? this.appSettings,
        acceptedClientRequests: acceptedClientRequests ?? const [],
        acceptedCoachRequest: acceptedCoachRequest,
      );
}
