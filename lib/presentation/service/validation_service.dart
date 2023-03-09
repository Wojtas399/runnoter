bool isNameOrSurnameValid(String value) {
  return RegExp(
    r"^[a-zA-Z]{2,}$",
  ).hasMatch(value);
}

bool isEmailValid(String value) {
  return RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  ).hasMatch(value);
}

bool isPasswordValid(String value) {
  return RegExp(
    r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$",
  ).hasMatch(value);
}
