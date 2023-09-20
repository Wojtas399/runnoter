part of 'chat_cubit.dart';

class ChatState extends CubitState<ChatState> {
  final String? recipientFullName;
  final List<ChatMessage>? messagesFromLatest;
  final String? messageToSend;
  final List<Uint8List> imagesToSend;

  const ChatState({
    required super.status,
    this.recipientFullName,
    this.messagesFromLatest,
    this.messageToSend,
    this.imagesToSend = const [],
  });

  @override
  List<Object?> get props => [
        status,
        recipientFullName,
        messagesFromLatest,
        messageToSend,
        imagesToSend,
      ];

  bool get canSubmitMessage =>
      messageToSend?.isNotEmpty == true || imagesToSend.isNotEmpty;

  @override
  ChatState copyWith({
    CubitStatus? status,
    String? recipientFullName,
    List<ChatMessage>? messagesFromLatest,
    String? messageToSend,
    bool messageToSendAsNull = false,
    List<Uint8List>? imagesToSend,
  }) =>
      ChatState(
        status: status ?? const CubitStatusComplete(),
        recipientFullName: recipientFullName ?? this.recipientFullName,
        messagesFromLatest: messagesFromLatest ?? this.messagesFromLatest,
        messageToSend:
            messageToSendAsNull ? null : messageToSend ?? this.messageToSend,
        imagesToSend: imagesToSend ?? this.imagesToSend,
      );
}

class ChatMessage extends Equatable {
  final String id;
  final MessageStatus status;
  final bool hasBeenSentByLoggedUser;
  final DateTime sendDateTime;
  final String? text;
  final List<MessageImage> images;

  const ChatMessage({
    required this.id,
    required this.status,
    required this.hasBeenSentByLoggedUser,
    required this.sendDateTime,
    this.text,
    this.images = const [],
  });

  @override
  List<Object?> get props => [
        id,
        status,
        hasBeenSentByLoggedUser,
        sendDateTime,
        text,
        images,
      ];
}
