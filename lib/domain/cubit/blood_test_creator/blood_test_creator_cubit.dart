import 'package:rxdart/rxdart.dart';

import '../../../../domain/repository/blood_test_repository.dart';
import '../../../data/entity/blood_test.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/blood_parameter.dart';
import '../../additional_model/cubit_state.dart';
import '../../additional_model/cubit_status.dart';
import '../../additional_model/cubit_with_status.dart';
import '../../additional_model/custom_exception.dart';
import '../../entity/user.dart';
import '../../repository/user_repository.dart';
import '../../service/list_service.dart';

part 'blood_test_creator_state.dart';

class BloodTestCreatorCubit extends CubitWithStatus<BloodTestCreatorState,
    BloodTestCreatorCubitInfo, BloodTestCreatorCubitError> {
  final UserRepository _userRepository;
  final BloodTestRepository _bloodTestRepository;
  final String userId;
  final String? bloodTestId;

  BloodTestCreatorCubit({
    required this.userId,
    this.bloodTestId,
    BloodTestCreatorState initialState = const BloodTestCreatorState(
      status: CubitStatusInitial(),
    ),
  })  : _userRepository = getIt.get<UserRepository>(),
        _bloodTestRepository = getIt<BloodTestRepository>(),
        super(initialState);

  Future<void> initialize() async {
    if (bloodTestId == null) {
      await for (final gender in _getUserGender()) {
        emit(state.copyWith(gender: gender));
        return;
      }
    }
    final Stream<(Gender, BloodTest?)> stream$ = Rx.combineLatest2(
      _getUserGender(),
      _bloodTestRepository.getTestById(
        bloodTestId: bloodTestId!,
        userId: userId,
      ),
      (Gender gender, BloodTest? bloodTest) => (gender, bloodTest),
    );
    await for (final params in stream$) {
      final Gender gender = params.$1;
      final BloodTest? bloodTest = params.$2;
      if (bloodTest != null) {
        emit(state.copyWith(
          gender: gender,
          bloodTest: bloodTest,
          date: bloodTest.date,
          parameterResults: bloodTest.parameterResults,
        ));
      }
      return;
    }
  }

  void dateChanged(DateTime date) {
    emit(state.copyWith(date: date));
  }

  void parameterValueChanged({
    required BloodParameter parameter,
    double? value,
  }) {
    final int parameterIndex = _findParameterIndex(parameter);
    final updatedParameterResults = [...?state.parameterResults];
    BloodParameterResult? parameterResult;
    if (value != null) {
      parameterResult = BloodParameterResult(
        parameter: parameter,
        value: value,
      );
    }
    if (parameterIndex >= 0) {
      if (parameterResult != null) {
        updatedParameterResults[parameterIndex] = parameterResult;
      } else {
        updatedParameterResults.removeAt(parameterIndex);
      }
    } else if (parameterResult != null) {
      updatedParameterResults.add(parameterResult);
    }
    emit(state.copyWith(
      parameterResults: updatedParameterResults,
    ));
  }

  Future<void> submit() async {
    if (!state.canSubmit) return;
    emitLoadingStatus();
    if (state.bloodTest != null) {
      try {
        await _tryToUpdateTest();
        emitCompleteStatus(info: BloodTestCreatorCubitInfo.bloodTestUpdated);
      } on EntityException catch (entityException) {
        if (entityException.code == EntityExceptionCode.entityNotFound) {
          emitErrorStatus(BloodTestCreatorCubitError.bloodTestNoLongerExists);
        }
      }
    } else {
      await _tryToAddTest();
      emitCompleteStatus(info: BloodTestCreatorCubitInfo.bloodTestAdded);
    }
  }

  Stream<Gender> _getUserGender() => _userRepository
      .getUserById(userId: userId)
      .whereNotNull()
      .map((User user) => user.gender);

  int _findParameterIndex(BloodParameter parameter) =>
      state.parameterResults?.indexWhere(
        (result) => result.parameter == parameter,
      ) ??
      -1;

  Future<void> _tryToUpdateTest() async =>
      await _bloodTestRepository.updateTest(
        bloodTestId: state.bloodTest!.id,
        userId: userId,
        date: state.date!,
        parameterResults: state.parameterResults!,
      );

  Future<void> _tryToAddTest() async => await _bloodTestRepository.addNewTest(
        userId: userId,
        date: state.date!,
        parameterResults: state.parameterResults!,
      );
}

enum BloodTestCreatorCubitInfo { bloodTestAdded, bloodTestUpdated }

enum BloodTestCreatorCubitError { bloodTestNoLongerExists }
