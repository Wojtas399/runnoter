import '../../entity/user.dart';

class RequiredDataCompletionEvent {
  const RequiredDataCompletionEvent();
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
