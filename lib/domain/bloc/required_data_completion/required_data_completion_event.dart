part of 'required_data_completion_bloc.dart';

class RequiredDataCompletionEvent {
  const RequiredDataCompletionEvent();
}

class RequiredDataCompletionAccountTypeChanged
    extends RequiredDataCompletionEvent {
  final AccountType accountType;

  const RequiredDataCompletionAccountTypeChanged({required this.accountType});
}

class RequiredDataCompletionEventGenderChanged
    extends RequiredDataCompletionEvent {
  final Gender gender;

  const RequiredDataCompletionEventGenderChanged({required this.gender});
}

class RequiredDataCompletionEventNameChanged
    extends RequiredDataCompletionEvent {
  final String name;

  const RequiredDataCompletionEventNameChanged({required this.name});
}

class RequiredDataCompletionEventSurnameChanged
    extends RequiredDataCompletionEvent {
  final String surname;

  const RequiredDataCompletionEventSurnameChanged({required this.surname});
}

class RequiredDataCompletionEventSubmit extends RequiredDataCompletionEvent {
  const RequiredDataCompletionEventSubmit();
}
