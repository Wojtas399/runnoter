import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/blood_reading.dart';
import '../../../domain/repository/blood_reading_repository.dart';
import '../../../domain/service/auth_service.dart';

class BloodReadingsCubit extends Cubit<List<BloodReadingsFromYear>?> {
  final AuthService _authService;
  final BloodReadingRepository _bloodReadingRepository;
  StreamSubscription<List<BloodReading>?>? _bloodReadingsListener;

  BloodReadingsCubit({
    required AuthService authService,
    required BloodReadingRepository bloodReadingRepository,
  })  : _authService = authService,
        _bloodReadingRepository = bloodReadingRepository,
        super(null);

  @override
  Future<void> close() {
    _bloodReadingsListener?.cancel();
    _bloodReadingsListener = null;
    return super.close();
  }

  void initialize() {
    _bloodReadingsListener ??= _authService.loggedUserId$
        .whereNotNull()
        .switchMap(
          (String loggedUserId) => _bloodReadingRepository.getAllReadings(
            userId: loggedUserId,
          ),
        )
        .listen(
          (List<BloodReading>? bloodReadings) => emit(
            _segregateBloodReadings(bloodReadings),
          ),
        );
  }

  List<BloodReadingsFromYear>? _segregateBloodReadings(
    List<BloodReading>? bloodReadings,
  ) {
    if (bloodReadings == null) {
      return null;
    }
    final List<BloodReadingsFromYear> segregatedReadings = [];
    for (final reading in bloodReadings) {
      final int readingYear = reading.date.year;
      final int yearIndex = segregatedReadings.indexWhere(
        (element) => element.year == readingYear,
      );
      if (yearIndex >= 0) {
        segregatedReadings[yearIndex].bloodReadings.add(reading);
      } else {
        segregatedReadings.add(
          BloodReadingsFromYear(
            year: readingYear,
            bloodReadings: [reading],
          ),
        );
      }
    }
    return segregatedReadings;
  }
}

class BloodReadingsFromYear extends Equatable {
  final int year;
  final List<BloodReading> bloodReadings;

  const BloodReadingsFromYear({
    required this.year,
    required this.bloodReadings,
  });

  @override
  List<Object?> get props => [
        year,
        bloodReadings,
      ];
}
