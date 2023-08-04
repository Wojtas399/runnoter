import 'package:mocktail/mocktail.dart';
import 'package:runnoter/domain/entity/user.dart';
import 'package:runnoter/domain/use_case/add_user_data_use_case.dart';

class MockAddUserDataUseCase extends Mock implements AddUserDataUseCase {
  MockAddUserDataUseCase() {
    registerFallbackValue(Gender.male);
  }

  void mock() {
    when(
      () => execute(
        userId: any(named: 'userId'),
        name: any(named: 'name'),
        surname: any(named: 'surname'),
        gender: any(named: 'gender'),
      ),
    ).thenAnswer((_) => Future.value());
  }
}
