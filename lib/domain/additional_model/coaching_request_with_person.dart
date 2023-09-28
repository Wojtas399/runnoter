import 'package:equatable/equatable.dart';

import '../entity/person.dart';

class CoachingRequestWithPerson extends Equatable {
  final String id;
  final Person person;

  const CoachingRequestWithPerson({required this.id, required this.person});

  @override
  List<Object?> get props => [id, person];
}
