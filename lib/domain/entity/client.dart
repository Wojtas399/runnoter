import 'package:equatable/equatable.dart';

import 'user.dart';

class Client extends Equatable {
  final String id;
  final Gender gender;
  final String name;
  final String surname;
  final String email;

  const Client({
    required this.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, email];
}
