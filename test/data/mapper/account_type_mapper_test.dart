import 'package:firebase/firebase.dart' as firebase;
import 'package:flutter_test/flutter_test.dart';
import 'package:runnoter/data/mapper/account_type_mapper.dart';
import 'package:runnoter/domain/entity/user.dart';

void main() {
  test(
    'map account type from dto, '
    'dto AccountType.runner should be mapped to domain AccountType.runner',
    () {
      const firebase.AccountType dtoAccountType = firebase.AccountType.runner;
      const AccountType expectedAccountType = AccountType.runner;

      final AccountType accountType = mapAccountTypeFromDto(dtoAccountType);

      expect(accountType, expectedAccountType);
    },
  );

  test(
    'map account type from dto, '
    'dto AccountType.coach should be mapped to domain AccountType.coach',
    () {
      const firebase.AccountType dtoAccountType = firebase.AccountType.coach;
      const AccountType expectedAccountType = AccountType.coach;

      final AccountType accountType = mapAccountTypeFromDto(dtoAccountType);

      expect(accountType, expectedAccountType);
    },
  );

  test(
    'map account type to dto, '
    'domain AccountType.runner should be mapped to dto AccountType.runner',
    () {
      const AccountType accountType = AccountType.runner;
      const firebase.AccountType expectedDtoAccountType =
          firebase.AccountType.runner;

      final firebase.AccountType dtoAccountType =
          mapAccountTypeToDto(accountType);

      expect(dtoAccountType, expectedDtoAccountType);
    },
  );

  test(
    'map account type to dto, '
    'domain AccountType.coach should be mapped to dto AccountType.coach',
    () {
      const AccountType accountType = AccountType.coach;
      const firebase.AccountType expectedDtoAccountType =
          firebase.AccountType.coach;

      final firebase.AccountType dtoAccountType =
          mapAccountTypeToDto(accountType);

      expect(dtoAccountType, expectedDtoAccountType);
    },
  );
}
