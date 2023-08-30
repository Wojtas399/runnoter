import 'package:firebase/firebase.dart';
import 'package:firebase/mapper/account_type_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'map account type from str, '
    'runner string should be mapped to AccountType.runner',
    () {
      const String accountTypeStr = 'runner';
      const AccountType expectedAccountType = AccountType.runner;

      final AccountType accountType = mapAccountTypeFromStr(accountTypeStr);

      expect(accountType, expectedAccountType);
    },
  );

  test(
    'map account type from str, '
    'coach string should be mapped to AccountType.coach',
    () {
      const String accountTypeStr = 'coach';
      const AccountType expectedAccountType = AccountType.coach;

      final AccountType accountType = mapAccountTypeFromStr(accountTypeStr);

      expect(accountType, expectedAccountType);
    },
  );

  test(
    'map account type to str, '
    'AccountType.runner should be mapped to runner string',
    () {
      const AccountType accountType = AccountType.runner;
      const String expectedAccountTypeStr = 'runner';

      final String accountTypeStr = mapAccountTypeToStr(accountType);

      expect(accountTypeStr, expectedAccountTypeStr);
    },
  );

  test(
    'map account type to str, '
    'AccountType.coach should be mapped to coach string',
    () {
      const AccountType accountType = AccountType.coach;
      const String expectedAccountTypeStr = 'coach';

      final String accountTypeStr = mapAccountTypeToStr(accountType);

      expect(accountTypeStr, expectedAccountTypeStr);
    },
  );
}
