import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/entity/blood_test.dart';
import '../../../data/entity/user.dart';
import '../../../data/interface/repository/blood_test_repository.dart';
import '../../../dependency_injection.dart';
import '../../additional_model/blood_parameter.dart';
import '../../repository/user_repository.dart';

part 'blood_test_preview_state.dart';

class BloodTestPreviewCubit extends Cubit<BloodTestPreviewState> {
  final UserRepository _userRepository;
  final BloodTestRepository _bloodTestRepository;
  final String userId;
  final String bloodTestId;
  StreamSubscription<(Gender, BloodTest?)>? _listener;

  BloodTestPreviewCubit({
    required this.userId,
    required this.bloodTestId,
    BloodTestPreviewState initialState = const BloodTestPreviewState(),
  })  : _userRepository = getIt<UserRepository>(),
        _bloodTestRepository = getIt<BloodTestRepository>(),
        super(initialState);

  @override
  Future<void> close() {
    _listener?.cancel();
    _listener = null;
    return super.close();
  }

  Future<void> initialize() async {
    _listener ??= Rx.combineLatest2(
      _getUserGender(),
      _bloodTestRepository.getTestById(
        bloodTestId: bloodTestId,
        userId: userId,
      ),
      (Gender gender, BloodTest? bloodTest) => (gender, bloodTest),
    ).listen(
      ((Gender, BloodTest?) params) => emit(state.copyWith(
        date: params.$2?.date,
        gender: params.$1,
        parameterResults: params.$2?.parameterResults,
      )),
    );
  }

  Future<void> deleteTest() async {
    await _bloodTestRepository.deleteTest(
      bloodTestId: bloodTestId,
      userId: userId,
    );
  }

  Stream<Gender> _getUserGender() => _userRepository
      .getUserById(userId: userId)
      .whereNotNull()
      .map((User user) => user.gender);
}
