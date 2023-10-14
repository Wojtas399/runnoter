import '../../../data/entity/user.dart';
import '../../../data/interface/service/auth_service.dart';
import '../../../dependency_injection.dart';
import '../../../ui/service/validation_service.dart' as validator;
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../use_case/add_user_data_use_case.dart';

part 'required_data_completion_state.dart';

class RequiredDataCompletionCubit extends CubitWithStatus<
    RequiredDataCompletionState, RequiredDataCompletionCubitInfo, dynamic> {
  final AuthService _authService;
  final AddUserDataUseCase _addUserDataUseCase;

  RequiredDataCompletionCubit({
    RequiredDataCompletionState initialState =
        const RequiredDataCompletionState(),
  })  : _authService = getIt<AuthService>(),
        _addUserDataUseCase = getIt<AddUserDataUseCase>(),
        super(initialState);

  void accountTypeChanged(AccountType accountType) {
    emit(state.copyWith(accountType: accountType));
  }

  void genderChanged(Gender? gender) {
    emit(state.copyWith(gender: gender));
  }

  void nameChanged(String name) {
    emit(state.copyWith(name: name));
  }

  void surnameChanged(String surname) {
    emit(state.copyWith(surname: surname));
  }

  void dateOfBirthChanged(DateTime dateOfBirth) {
    emit(state.copyWith(dateOfBirth: dateOfBirth));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emitLoadingStatus();
    final String? loggedUserId = await _authService.loggedUserId$.first;
    final String? loggedUserEmail = await _authService.loggedUserEmail$.first;
    if (loggedUserId == null || loggedUserEmail == null) {
      emitNoLoggedUserStatus();
      return;
    }
    await _addUserDataUseCase.execute(
      userId: loggedUserId,
      email: loggedUserEmail,
      name: state.name,
      surname: state.surname,
      gender: state.gender,
      accountType: state.accountType,
      dateOfBirth: state.dateOfBirth!,
    );
    emitCompleteStatus(info: RequiredDataCompletionCubitInfo.userDataAdded);
  }
}

enum RequiredDataCompletionCubitInfo { userDataAdded }
