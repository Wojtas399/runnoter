import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../dependency_injection.dart';
import '../../../data/model/person.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/person/person_repository.dart';

part 'person_details_state.dart';

class PersonDetailsCubit extends Cubit<PersonDetailsState> {
  final String _personId;
  final PersonRepository _personRepository;
  StreamSubscription<Person?>? _personListener;

  PersonDetailsCubit({required String personId})
      : _personId = personId,
        _personRepository = getIt<PersonRepository>(),
        super(const PersonDetailsState());

  @override
  Future<void> close() {
    _personListener?.cancel();
    _personListener = null;
    return super.close();
  }

  void initialize() {
    _personListener ??=
        _personRepository.getPersonById(personId: _personId).listen(
              (Person? client) => emit(
                state.copyWith(
                  gender: client?.gender,
                  name: client?.name,
                  surname: client?.surname,
                  email: client?.email,
                  dateOfBirth: client?.dateOfBirth,
                ),
              ),
            );
  }
}
