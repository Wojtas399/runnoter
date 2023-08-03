abstract class ReauthenticationFormEvent {
  const ReauthenticationFormEvent();
}

class ReauthenticationFormEventPasswordChanged
    extends ReauthenticationFormEvent {
  final String? password;

  const ReauthenticationFormEventPasswordChanged({this.password});
}

class ReauthenticationFormEventUsePassword extends ReauthenticationFormEvent {
  const ReauthenticationFormEventUsePassword();
}

class ReauthenticationFormEventUseGoogle extends ReauthenticationFormEvent {
  const ReauthenticationFormEventUseGoogle();
}

class ReauthenticationFormEventUseFacebook extends ReauthenticationFormEvent {
  const ReauthenticationFormEventUseFacebook();
}
