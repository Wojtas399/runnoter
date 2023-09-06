part of 'chat_cubit.dart';

class ChatState extends BlocState<ChatState> {
  final String? loggedUserId;
  final String? recipientFullName;
  final List<Message>? messagesFromLatest;
  final String? messageToSend;

  const ChatState({
    required super.status,
    this.loggedUserId,
    this.recipientFullName,
    this.messagesFromLatest,
    this.messageToSend,
  });

  @override
  List<Object?> get props => [
        status,
        loggedUserId,
        recipientFullName,
        messagesFromLatest,
        messageToSend,
      ];

  bool get canSubmitMessage =>
      loggedUserId?.isNotEmpty == true && messageToSend?.isNotEmpty == true;

  @override
  ChatState copyWith({
    BlocStatus? status,
    String? loggedUserId,
    String? recipientFullName,
    List<Message>? messagesFromLatest,
    String? messageToSend,
    bool messageToSendAsNull = false,
  }) =>
      ChatState(
        status: status ?? const BlocStatusComplete(),
        loggedUserId: loggedUserId ?? this.loggedUserId,
        recipientFullName: recipientFullName ?? this.recipientFullName,
        messagesFromLatest: messagesFromLatest ?? this.messagesFromLatest,
        messageToSend:
            messageToSendAsNull ? null : messageToSend ?? this.messageToSend,
      );
}
