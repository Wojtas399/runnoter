import '../firebase.dart';

AccountType mapAccountTypeFromStr(String accountTypeStr) =>
    AccountType.values.byName(accountTypeStr);

String mapAccountTypeToStr(AccountType accountType) => accountType.name;
