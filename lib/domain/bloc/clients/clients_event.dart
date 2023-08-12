part of 'clients_bloc.dart';

abstract class ClientsEvent {
  const ClientsEvent();
}

class ClientsEventInitialize extends ClientsEvent {
  const ClientsEventInitialize();
}
