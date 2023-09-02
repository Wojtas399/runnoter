part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatEventInitialize extends ChatEvent {
  const ChatEventInitialize();
}

class ChatEventSentMessage extends ChatEvent {
  final String message;

  const ChatEventSentMessage({required this.message});
}
