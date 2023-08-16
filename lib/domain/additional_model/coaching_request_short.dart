import 'package:equatable/equatable.dart';

import '../entity/person.dart';

class CoachingRequestShort extends Equatable {
  final String id;
  final Person personToDisplay;

  const CoachingRequestShort({required this.id, required this.personToDisplay});

  @override
  List<Object?> get props => [id, personToDisplay];
}
