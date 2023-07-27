bool isNameOrSurnameValid(String value) {
  return RegExp(
    r'^[a-zA-ZżźćńółęąśŻŹĆĄŚĘŁÓŃ]{2,}$',
  ).hasMatch(value);
}

bool isEmailValid(String value) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(value);
}

bool isPasswordValid(String value) {
  return RegExp(
    r'^(?=.*?[A-ZŻŹĆĄŚĘŁÓŃ])(?=.*?[a-zżźćńółęąś])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$',
  ).hasMatch(value);
}
