part of 'reauthentication_bloc.dart';

abstract class ReauthenticationEvent {
  const ReauthenticationEvent();
}

class ReauthenticationEventPasswordChanged extends ReauthenticationEvent {
  final String? password;

  const ReauthenticationEventPasswordChanged({this.password});
}

class ReauthenticationEventUsePassword extends ReauthenticationEvent {
  const ReauthenticationEventUsePassword();
}

class ReauthenticationEventUseGoogle extends ReauthenticationEvent {
  const ReauthenticationEventUseGoogle();
}

class ReauthenticationEventUseFacebook extends ReauthenticationEvent {
  const ReauthenticationEventUseFacebook();
}
