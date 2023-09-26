part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final List<String> idsOfClientsWithAwaitingMessages;
  final bool areThereUnreadMessagesFromCoach;
  final int numberOfCoachingRequestsReceivedFromClients;
  final int numberOfCoachingRequestsReceivedFromCoaches;

  const NotificationsState({
    this.idsOfClientsWithAwaitingMessages = const [],
    this.areThereUnreadMessagesFromCoach = false,
    this.numberOfCoachingRequestsReceivedFromClients = 0,
    this.numberOfCoachingRequestsReceivedFromCoaches = 0,
  });

  @override
  List<Object?> get props => [
        idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromClients,
        numberOfCoachingRequestsReceivedFromCoaches,
      ];

  NotificationsState copyWith({
    List<String>? idsOfClientsWithAwaitingMessages,
    bool? areThereUnreadMessagesFromCoach,
    int? numberOfCoachingRequestsReceivedFromClients,
    int? numberOfCoachingRequestsReceivedFromCoaches,
  }) =>
      NotificationsState(
        idsOfClientsWithAwaitingMessages: idsOfClientsWithAwaitingMessages ??
            this.idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach: areThereUnreadMessagesFromCoach ??
            this.areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromClients:
            numberOfCoachingRequestsReceivedFromClients ??
                this.numberOfCoachingRequestsReceivedFromClients,
        numberOfCoachingRequestsReceivedFromCoaches:
            numberOfCoachingRequestsReceivedFromCoaches ??
                this.numberOfCoachingRequestsReceivedFromCoaches,
      );
}
