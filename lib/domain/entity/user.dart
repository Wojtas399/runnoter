import 'entity.dart';
import 'settings.dart';

enum AccountType { coach, runner }

enum Gender { male, female }

sealed class User extends Entity {
  final Gender gender;
  final String name;
  final String surname;
  final Settings settings;
  final String? coachId;

  const User({
    required super.id,
    required this.gender,
    required this.name,
    required this.surname,
    required this.settings,
    this.coachId,
  });
}

class Runner extends User {
  const Runner({
    required super.id,
    required super.gender,
    required super.name,
    required super.surname,
    required super.settings,
    super.coachId,
  });

  @override
  List<Object?> get props => [id, gender, name, surname, settings, coachId];
}

class Coach extends User {
  final List<String> clientIds;

  const Coach({
    required super.id,
    required super.gender,
    required super.name,
    required super.surname,
    required super.settings,
    super.coachId,
    required this.clientIds,
  });

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        surname,
        settings,
        coachId,
        clientIds,
      ];
}
