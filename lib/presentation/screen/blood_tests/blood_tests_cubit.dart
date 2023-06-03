import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/blood_test.dart';
import '../../../domain/repository/blood_test_repository.dart';
import '../../../domain/service/auth_service.dart';

class BloodTestsCubit extends Cubit<List<BloodTestsFromYear>?> {
  final AuthService _authService;
  final BloodTestRepository _bloodTestRepository;
  StreamSubscription<List<BloodTest>?>? _bloodTestsListener;

  BloodTestsCubit({
    required AuthService authService,
    required BloodTestRepository bloodTestRepository,
  })  : _authService = authService,
        _bloodTestRepository = bloodTestRepository,
        super(null);

  @override
  Future<void> close() {
    _bloodTestsListener?.cancel();
    _bloodTestsListener = null;
    return super.close();
  }

  void initialize() {
    _bloodTestsListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _bloodTestRepository.getAllTests(
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<BloodTest>? bloodTests) => emit(
            _segregateBloodTests(bloodTests),
          ),
        );
  }

  List<BloodTestsFromYear>? _segregateBloodTests(
    List<BloodTest>? bloodTests,
  ) {
    if (bloodTests == null) {
      return null;
    }
    final List<BloodTestsFromYear> segregatedTests = [];
    for (final test in bloodTests) {
      final int year = test.date.year;
      final int yearIndex = segregatedTests.indexWhere(
        (element) => element.year == year,
      );
      if (yearIndex >= 0) {
        segregatedTests[yearIndex].bloodTests.add(test);
      } else {
        segregatedTests.add(
          BloodTestsFromYear(
            year: year,
            bloodTests: [test],
          ),
        );
      }
    }
    return segregatedTests;
  }
}

class BloodTestsFromYear extends Equatable {
  final int year;
  final List<BloodTest> bloodTests;

  const BloodTestsFromYear({
    required this.year,
    required this.bloodTests,
  });

  @override
  List<Object?> get props => [
        year,
        bloodTests,
      ];
}
