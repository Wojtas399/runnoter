part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final List<String> idsOfClientsWithAwaitingMessages;
  final bool areThereUnreadMessagesFromCoach;
  final int numberOfCoachingRequestsReceivedFromClients;

  const NotificationsState({
    this.idsOfClientsWithAwaitingMessages = const [],
    this.areThereUnreadMessagesFromCoach = false,
    this.numberOfCoachingRequestsReceivedFromClients = 0,
  });

  @override
  List<Object?> get props => [
        idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromClients,
      ];

  NotificationsState copyWith({
    List<String>? idsOfClientsWithAwaitingMessages,
    bool? areThereUnreadMessagesFromCoach,
    int? numberOfCoachingRequestsReceivedFromClients,
  }) =>
      NotificationsState(
        idsOfClientsWithAwaitingMessages: idsOfClientsWithAwaitingMessages ??
            this.idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach: areThereUnreadMessagesFromCoach ??
            this.areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromClients:
            numberOfCoachingRequestsReceivedFromClients ??
                this.numberOfCoachingRequestsReceivedFromClients,
      );
}
