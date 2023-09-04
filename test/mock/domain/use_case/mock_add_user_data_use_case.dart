import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

class MockAddUserDataUseCase extends Mock implements AddUserDataUseCase {
  MockAddUserDataUseCase() {
    registerFallbackValue(AccountType.runner);
    registerFallbackValue(Gender.male);
  }

  void mock() {
    when(
      () => execute(
        accountType: any(named: 'accountType'),
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        gender: any(named: 'gender'),
        email: any(named: 'email'),
        dateOfBirth: any(named: 'dateOfBirth'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
