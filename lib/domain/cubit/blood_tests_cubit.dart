import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dependency_injection.dart';
import '../entity/blood_test.dart';
import '../repository/blood_test_repository.dart';

class BloodTestsCubit extends Cubit<List<BloodTestsFromYear>?> {
  final String _userId;
  final BloodTestRepository _bloodTestRepository;
  StreamSubscription<List<BloodTest>?>? _bloodTestsListener;

  BloodTestsCubit({required String userId})
      : _userId = userId,
        _bloodTestRepository = getIt<BloodTestRepository>(),
        super(null);

  @override
  Future<void> close() {
    _bloodTestsListener?.cancel();
    _bloodTestsListener = null;
    return super.close();
  }

  void initialize() {
    _bloodTestsListener ??= _bloodTestRepository
        .getAllTests(userId: _userId)
        .listen(_onBloodTestsChanged);
  }

  void _onBloodTestsChanged(List<BloodTest>? bloodTests) {
    final segregatedTests = _segregateBloodTests(bloodTests);
    if (segregatedTests == null) return;
    for (final testsFromYear in segregatedTests) {
      testsFromYear.bloodTests.sort((t1, t2) => t2.date.compareTo(t1.date));
    }
    emit(segregatedTests);
  }

  List<BloodTestsFromYear>? _segregateBloodTests(List<BloodTest>? bloodTests) {
    if (bloodTests == null) return null;
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
          BloodTestsFromYear(year: year, bloodTests: [test]),
        );
      }
    }
    return segregatedTests;
  }
}

class BloodTestsFromYear extends Equatable {
  final int year;
  final List<BloodTest> bloodTests;

  const BloodTestsFromYear({required this.year, required this.bloodTests});

  @override
  List<Object?> get props => [year, bloodTests];
}
