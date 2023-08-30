part of 'chat_bloc.dart';

class ChatState extends BlocState<ChatState> {
  final String? senderFullName;
  final String? recipientFullName;
  final List<Message>? messages;

  const ChatState({
    required super.status,
    this.senderFullName,
    this.recipientFullName,
    this.messages,
  });

  @override
  List<Object?> get props => [
        status,
        senderFullName,
        recipientFullName,
        messages,
      ];

  @override
  ChatState copyWith({
    BlocStatus? status,
    String? senderFullName,
    String? recipientFullName,
    List<Message>? messages,
  }) =>
      ChatState(
        status: status ?? const BlocStatusComplete(),
        senderFullName: senderFullName ?? this.senderFullName,
        recipientFullName: recipientFullName ?? this.recipientFullName,
        messages: messages ?? this.messages,
      );
}
