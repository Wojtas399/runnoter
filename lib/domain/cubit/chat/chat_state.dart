part of 'chat_cubit.dart';

class ChatState extends CubitState<ChatState> {
  final String? loggedUserId;
  final String? recipientFullName;
  final List<ChatMessage>? messagesFromLatest;
  final String? messageToSend;
  final List<Uint8List> imagesToSend;

  const ChatState({
    required super.status,
    this.loggedUserId,
    this.recipientFullName,
    this.messagesFromLatest,
    this.messageToSend,
    this.imagesToSend = const [],
  });

  @override
  List<Object?> get props => [
        status,
        loggedUserId,
        recipientFullName,
        messagesFromLatest,
        messageToSend,
        imagesToSend,
      ];

  bool get canSubmitMessage =>
      loggedUserId?.isNotEmpty == true &&
      (messageToSend?.isNotEmpty == true || imagesToSend.isNotEmpty);

  @override
  ChatState copyWith({
    CubitStatus? status,
    String? loggedUserId,
    String? recipientFullName,
    List<ChatMessage>? messagesFromLatest,
    String? messageToSend,
    bool messageToSendAsNull = false,
    List<Uint8List>? imagesToSend,
  }) =>
      ChatState(
        status: status ?? const CubitStatusComplete(),
        loggedUserId: loggedUserId ?? this.loggedUserId,
        recipientFullName: recipientFullName ?? this.recipientFullName,
        messagesFromLatest: messagesFromLatest ?? this.messagesFromLatest,
        messageToSend:
            messageToSendAsNull ? null : messageToSend ?? this.messageToSend,
        imagesToSend: imagesToSend ?? this.imagesToSend,
      );
}

class ChatMessage extends Equatable {
  final String id;
  final String senderId;
  final DateTime sendDateTime;
  final String? text;
  final List<MessageImage> images;

  const ChatMessage({
    required this.id,
    required this.senderId,
    required this.sendDateTime,
    this.text,
    this.images = const [],
  });

  @override
  List<Object?> get props => [id, senderId, sendDateTime, text, images];
}
