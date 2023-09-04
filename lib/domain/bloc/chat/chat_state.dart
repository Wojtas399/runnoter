part of 'chat_bloc.dart';

class ChatState extends BlocState<ChatState> {
  final String? loggedUserId;
  final String? senderFullName;
  final String? recipientFullName;
  final List<Message>? messages;
  final String? messageToSend;

  const ChatState({
    required super.status,
    this.loggedUserId,
    this.senderFullName,
    this.recipientFullName,
    this.messages,
    this.messageToSend,
  });

  @override
  List<Object?> get props => [
        status,
        loggedUserId,
        senderFullName,
        recipientFullName,
        messages,
        messageToSend,
      ];

  bool get canSubmitMessage =>
      loggedUserId?.isNotEmpty == true && messageToSend?.isNotEmpty == true;

  @override
  ChatState copyWith({
    BlocStatus? status,
    String? loggedUserId,
    String? senderFullName,
    String? recipientFullName,
    List<Message>? messages,
    String? messageToSend,
    bool messageToSendAsNull = false,
  }) =>
      ChatState(
        status: status ?? const BlocStatusComplete(),
        loggedUserId: loggedUserId ?? this.loggedUserId,
        senderFullName: senderFullName ?? this.senderFullName,
        recipientFullName: recipientFullName ?? this.recipientFullName,
        messages: messages ?? this.messages,
        messageToSend:
            messageToSendAsNull ? null : messageToSend ?? this.messageToSend,
      );
}
