part of 'chat_cubit.dart';

class ChatState extends Equatable {
  final String? recipientFullName;
  final bool isRecipientTyping;
  final List<ChatMessage>? messagesFromLatest;
  final String? messageToSend;
  final List<Uint8List> imagesToSend;

  const ChatState({
    this.recipientFullName,
    this.isRecipientTyping = false,
    this.messagesFromLatest,
    this.messageToSend,
    this.imagesToSend = const [],
  });

  @override
  List<Object?> get props => [
        recipientFullName,
        isRecipientTyping,
        messagesFromLatest,
        messageToSend,
        imagesToSend,
      ];

  bool get canSubmitMessage =>
      messageToSend?.isNotEmpty == true || imagesToSend.isNotEmpty;

  ChatState copyWith({
    String? recipientFullName,
    bool? isRecipientTyping,
    List<ChatMessage>? messagesFromLatest,
    String? messageToSend,
    bool messageToSendAsNull = false,
    List<Uint8List>? imagesToSend,
  }) =>
      ChatState(
        recipientFullName: recipientFullName ?? this.recipientFullName,
        isRecipientTyping: isRecipientTyping ?? this.isRecipientTyping,
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
  final DateTime dateTime;
  final String? text;
  final List<MessageImage> images;

  const ChatMessage({
    required this.id,
    required this.status,
    required this.hasBeenSentByLoggedUser,
    required this.dateTime,
    this.text,
    this.images = const [],
  });

  @override
  List<Object?> get props => [
        id,
        status,
        hasBeenSentByLoggedUser,
        dateTime,
        text,
        images,
      ];
}
