import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/presentation/service/validation_service.dart';

void main() {
  test(
    "is name or surname valid, value contains at least one digit, should be false",
    () {
      const String value = 'name1';

      final bool isValid = isNameOrSurnameValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is name or surname valid, value contains at least one special character, should be false",
    () {
      const String value = 'name!';

      final bool isValid = isNameOrSurnameValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is name or surname valid, length is lower than 2, should be false",
    () {
      const String value = 's';

      final bool isValid = isNameOrSurnameValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is name or surname valid, value contains only A-Z and a-z and length is higher than 2, should be true",
    () {
      const String value = 'surname';

      final bool isValid = isNameOrSurnameValid(value);

      expect(isValid, true);
    },
  );

  test(
    "is email valid, value doesn't contain monkey symbol, should be false",
    () {
      const String value = 'emailexample.com';

      final bool isValid = isEmailValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is email valid, value doesn't contain domain name, should be false",
    () {
      const String value = 'email@example.';

      final bool isValid = isEmailValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is email valid, value is too short, should be false",
    () {
      const String value = 'email';

      final bool isValid = isEmailValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is password valid, value doesn't contain any upper character, should be false",
    () {
      const String value = 'password1@';

      final bool isValid = isPasswordValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is password valid, value doesn't contain any lower character, should be false",
    () {
      const String value = 'PASSWORD1@';

      final bool isValid = isPasswordValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is password valid, value doesn't contain any digit, should be false",
    () {
      const String value = 'Password@';

      final bool isValid = isPasswordValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is password valid, value doesn't contain any special character, should be false",
    () {
      const String value = 'Password1';

      final bool isValid = isPasswordValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is password valid, length is lower than 6, should be false",
    () {
      const String value = 'passw';

      final bool isValid = isPasswordValid(value);

      expect(isValid, false);
    },
  );

  test(
    "is password valid, value performs the conditions, should be true",
    () {
      const String value = 'Password1@';

      final bool isValid = isPasswordValid(value);

      expect(isValid, true);
    },
  );
}
