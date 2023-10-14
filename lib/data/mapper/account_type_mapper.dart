import 'package:firebase/firebase.dart' as firebase;

import '../entity/user.dart';

AccountType mapAccountTypeFromDto(firebase.AccountType dtoAccountType) =>
    switch (dtoAccountType) {
      firebase.AccountType.runner => AccountType.runner,
      firebase.AccountType.coach => AccountType.coach,
    };

firebase.AccountType mapAccountTypeToDto(AccountType accountType) =>
    switch (accountType) {
      AccountType.runner => firebase.AccountType.runner,
      AccountType.coach => firebase.AccountType.coach,
    };
