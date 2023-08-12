part of 'clients_bloc.dart';

abstract class ClientsEvent {
  const ClientsEvent();
}

class ClientsEventInitialize extends ClientsEvent {
  const ClientsEventInitialize();
}

class ClientsEventDeleteRequest extends ClientsEvent {
  final String requestId;

  const ClientsEventDeleteRequest({required this.requestId});
}

class ClientsEventDeleteClient extends ClientsEvent {
  final String clientId;

  const ClientsEventDeleteClient({required this.clientId});
}
