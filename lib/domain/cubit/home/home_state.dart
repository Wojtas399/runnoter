part of 'home_cubit.dart';

class HomeState extends CubitState<HomeState> {
  final AccountType? accountType;
  final String? loggedUserName;
  final Settings? appSettings;
  final List<CoachingRequestShort> acceptedClientRequests;
  final CoachingRequestShort? acceptedCoachRequest;
  final List<String>? idsOfClientsWithAwaitingMessages;

  const HomeState({
    required super.status,
    this.accountType,
    this.loggedUserName,
    this.appSettings,
    this.acceptedClientRequests = const [],
    this.acceptedCoachRequest,
    this.idsOfClientsWithAwaitingMessages,
  });

  @override
  List<Object?> get props => [
        status,
        accountType,
        loggedUserName,
        appSettings,
        acceptedClientRequests,
        acceptedCoachRequest,
        idsOfClientsWithAwaitingMessages,
      ];

  @override
  HomeState copyWith({
    CubitStatus? status,
    AccountType? accountType,
    String? loggedUserName,
    Settings? appSettings,
    List<CoachingRequestShort>? acceptedClientRequests,
    CoachingRequestShort? acceptedCoachRequest,
    List<String>? idsOfClientsWithAwaitingMessages,
  }) =>
      HomeState(
        status: status ?? const CubitStatusComplete(),
        accountType: accountType ?? this.accountType,
        loggedUserName: loggedUserName ?? this.loggedUserName,
        appSettings: appSettings ?? this.appSettings,
        acceptedClientRequests: acceptedClientRequests ?? const [],
        acceptedCoachRequest: acceptedCoachRequest,
        idsOfClientsWithAwaitingMessages: idsOfClientsWithAwaitingMessages ??
            this.idsOfClientsWithAwaitingMessages,
      );
}
