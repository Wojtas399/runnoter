import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../../domain/model/blood_reading.dart';
import '../../../domain/repository/blood_reading_repository.dart';
import '../../../domain/service/auth_service.dart';

class BloodReadingsCubit extends Cubit<List<BloodReading>?> {
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
          (List<BloodReading>? bloodReadings) => emit(bloodReadings),
        );
  }
}
