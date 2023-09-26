part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final int numberOfCoachingRequestsReceivedFromClients;

  const NotificationsState({
    this.numberOfCoachingRequestsReceivedFromClients = 0,
  });

  @override
  List<Object?> get props => [
        numberOfCoachingRequestsReceivedFromClients,
      ];

  NotificationsState copyWith({
    int? numberOfCoachingRequestsReceivedFromClients,
  }) =>
      NotificationsState(
        numberOfCoachingRequestsReceivedFromClients:
            numberOfCoachingRequestsReceivedFromClients ??
                this.numberOfCoachingRequestsReceivedFromClients,
      );
}
