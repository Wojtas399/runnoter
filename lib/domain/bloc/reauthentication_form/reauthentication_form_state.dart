import 'package:equatable/equatable.dart';

abstract class ReauthenticationFormState extends Equatable {
  final String? email;

  const ReauthenticationFormState({this.email});

  @override
  List<Object?> get props => [email];
}

class ReauthenticationFormStateInitial extends ReauthenticationFormState {
  const ReauthenticationFormStateInitial({super.email});
}

class ReauthenticationFormStateLoading extends ReauthenticationFormState {
  final ReauthenticationFormType formType;

  const ReauthenticationFormStateLoading({
    required this.formType,
    super.email,
  });

  @override
  List<Object?> get props => [formType, email];
}

class ReauthenticationFormStateComplete extends ReauthenticationFormState {
  const ReauthenticationFormStateComplete({super.email});
}

class ReauthenticationFormStateWrongPassword extends ReauthenticationFormState {
  const ReauthenticationFormStateWrongPassword({super.email});
}

class ReauthenticationFormStateUserMismatch extends ReauthenticationFormState {
  const ReauthenticationFormStateUserMismatch({super.email});
}

class ReauthenticationFormStateNoInternetConnection
    extends ReauthenticationFormState {
  const ReauthenticationFormStateNoInternetConnection({super.email});
}

enum ReauthenticationFormType { password, google, facebook }
