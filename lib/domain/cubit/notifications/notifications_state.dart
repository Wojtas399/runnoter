part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  final List<CoachingRequestShort> acceptedClientRequests;
  final CoachingRequestShort? acceptedCoachRequest;
  final List<String> idsOfClientsWithAwaitingMessages;
  final bool areThereUnreadMessagesFromCoach;
  final int numberOfCoachingRequestsFromClients;
  final int numberOfCoachingRequestsFromCoaches;

  const NotificationsState({
    this.acceptedClientRequests = const [],
    this.acceptedCoachRequest,
    this.idsOfClientsWithAwaitingMessages = const [],
    this.areThereUnreadMessagesFromCoach = false,
    this.numberOfCoachingRequestsFromClients = 0,
    this.numberOfCoachingRequestsFromCoaches = 0,
  });

  @override
  List<Object?> get props => [
        acceptedClientRequests,
        acceptedCoachRequest,
        idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsFromClients,
        numberOfCoachingRequestsFromCoaches,
      ];

  NotificationsState copyWith({
    List<CoachingRequestShort>? acceptedClientRequests,
    CoachingRequestShort? acceptedCoachRequest,
    List<String>? idsOfClientsWithAwaitingMessages,
    bool? areThereUnreadMessagesFromCoach,
    int? numberOfCoachingRequestsFromClients,
    int? numberOfCoachingRequestsFromCoaches,
  }) =>
      NotificationsState(
        acceptedClientRequests: acceptedClientRequests ?? const [],
        acceptedCoachRequest: acceptedCoachRequest,
        idsOfClientsWithAwaitingMessages: idsOfClientsWithAwaitingMessages ??
            this.idsOfClientsWithAwaitingMessages,
        areThereUnreadMessagesFromCoach: areThereUnreadMessagesFromCoach ??
            this.areThereUnreadMessagesFromCoach,
        numberOfCoachingRequestsFromClients:
            numberOfCoachingRequestsFromClients ??
                this.numberOfCoachingRequestsFromClients,
        numberOfCoachingRequestsFromCoaches:
            numberOfCoachingRequestsFromCoaches ??
                this.numberOfCoachingRequestsFromCoaches,
      );
}
