part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final List<CoachingRequestShort> acceptedClientRequests;
  final List<String> idsOfClientsWithAwaitingMessages;
  final bool areThereUnreadMessagesFromCoach;
  final int numberOfCoachingRequestsReceivedFromClients;
  final int numberOfCoachingRequestsReceivedFromCoaches;

  const NotificationsState({
    this.acceptedClientRequests = const [],
    this.idsOfClientsWithAwaitingMessages = const [],
    this.areThereUnreadMessagesFromCoach = false,
    this.numberOfCoachingRequestsReceivedFromClients = 0,
    this.numberOfCoachingRequestsReceivedFromCoaches = 0,
  });

  @override
  List<Object?> get props => [
        acceptedClientRequests,
        idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsReceivedFromClients,
        numberOfCoachingRequestsReceivedFromCoaches,
      ];

  NotificationsState copyWith({
    List<CoachingRequestShort>? acceptedClientRequests,
    List<String>? idsOfClientsWithAwaitingMessages,
    bool? areThereUnreadMessagesFromCoach,
    int? numberOfCoachingRequestsReceivedFromClients,
    int? numberOfCoachingRequestsReceivedFromCoaches,
  }) =>
      NotificationsState(
        acceptedClientRequests: acceptedClientRequests ?? const [],
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
