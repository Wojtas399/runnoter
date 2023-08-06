import 'entity.dart';
import 'settings.dart';

enum Gender {
  male,
  female,
}

sealed class User extends Entity {
  final Gender gender;
  final String name;
  final String surname;
  final Settings settings;

  const User({
    required super.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.settings,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, settings];
}

class Coach extends User {
  final List<Runner> runners;

  const Coach({
    required super.id,
    required super.gender,
    required super.name,
    required super.surname,
    required super.settings,
    required this.runners,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, settings, runners];
}

class Runner extends User {
  final String? coachId;

  const Runner({
    required super.id,
    required super.gender,
    required super.name,
    required super.surname,
    required super.settings,
    this.coachId,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, settings, coachId];
}
