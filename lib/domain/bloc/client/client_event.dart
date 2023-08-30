part of 'client_bloc.dart';

abstract class ClientEvent {
  const ClientEvent();
}

class ClientEventInitialize extends ClientEvent {
  const ClientEventInitialize();
}
