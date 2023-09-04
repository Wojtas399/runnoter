part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();
}

class ChatEventInitialize extends ChatEvent {
  const ChatEventInitialize();
}

class ChatEventMessageChanged extends ChatEvent {
  final String message;

  const ChatEventMessageChanged({required this.message});
}

class ChatEventSubmitMessage extends ChatEvent {
  const ChatEventSubmitMessage();
}
