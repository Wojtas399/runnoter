import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dependency_injection.dart';
import '../../../presentation/service/validation_service.dart' as validator;
import '../../additional_model/bloc_state.dart';
import '../../additional_model/bloc_status.dart';
import '../../additional_model/bloc_with_status.dart';
import '../../entity/user.dart';
import '../../service/auth_service.dart';
import '../../use_case/add_user_data_use_case.dart';

part 'required_data_completion_event.dart';
part 'required_data_completion_state.dart';

class RequiredDataCompletionBloc extends BlocWithStatus<
    RequiredDataCompletionEvent,
    RequiredDataCompletionState,
    RequiredDataCompletionBlocInfo,
    dynamic> {
  final AuthService _authService;
  final AddUserDataUseCase _addUserDataUseCase;

  RequiredDataCompletionBloc({
    RequiredDataCompletionState state = const RequiredDataCompletionState(),
  })  : _authService = getIt<AuthService>(),
        _addUserDataUseCase = getIt<AddUserDataUseCase>(),
        super(state) {
    on<RequiredDataCompletionEventAccountTypeChanged>(_accountTypeChanged);
    on<RequiredDataCompletionEventGenderChanged>(_genderChanged);
    on<RequiredDataCompletionEventNameChanged>(_nameChanged);
    on<RequiredDataCompletionEventSurnameChanged>(_surnameChanged);
    on<RequiredDataCompletionEventSubmit>(_submit);
  }

  void _accountTypeChanged(
    RequiredDataCompletionEventAccountTypeChanged event,
    Emitter<RequiredDataCompletionState> emit,
  ) {
    emit(state.copyWith(
      accountType: event.accountType,
    ));
  }

  void _genderChanged(
    RequiredDataCompletionEventGenderChanged event,
    Emitter<RequiredDataCompletionState> emit,
  ) {
    emit(state.copyWith(
      gender: event.gender,
    ));
  }

  void _nameChanged(
    RequiredDataCompletionEventNameChanged event,
    Emitter<RequiredDataCompletionState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
    ));
  }

  void _surnameChanged(
    RequiredDataCompletionEventSurnameChanged event,
    Emitter<RequiredDataCompletionState> emit,
  ) {
    emit(state.copyWith(
      surname: event.surname,
    ));
  }

  Future<void> _submit(
    RequiredDataCompletionEventSubmit event,
    Emitter<RequiredDataCompletionState> emit,
  ) async {
    if (!state.canSubmit) return;
    emitLoadingStatus(emit);
    final String? loggedUserId = await _authService.loggedUserId$.first;
    final String? loggedUserEmail = await _authService.loggedUserEmail$.first;
    if (loggedUserId == null || loggedUserEmail == null) {
      emitNoLoggedUserStatus(emit);
      return;
    }
    await _addUserDataUseCase.execute(
      userId: loggedUserId,
      email: loggedUserEmail,
      name: state.name,
      surname: state.surname,
      gender: state.gender,
      accountType: state.accountType,
      dateOfBirth: DateTime(2023), //TODO: Implement date of birth
    );
    emitCompleteStatus(
      emit,
      info: RequiredDataCompletionBlocInfo.userDataAdded,
    );
  }
}

enum RequiredDataCompletionBlocInfo { userDataAdded }
