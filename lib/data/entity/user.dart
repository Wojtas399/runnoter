import '../../domain/additional_model/settings.dart';
import '../../domain/entity/entity.dart';

enum AccountType { coach, runner }

enum Gender { male, female }

class User extends Entity {
  final AccountType accountType;
  final Gender gender;
  final String name;
  final String surname;
  final String email;
  final DateTime dateOfBirth;
  final Settings settings;
  final String? coachId;

  const User({
    required super.id,
    required this.accountType,
    required this.gender,
    required this.name,
    required this.surname,
    required this.email,
    required this.dateOfBirth,
    required this.settings,
    this.coachId,
  });

  @override
  List<Object?> get props => [
        id,
        gender,
        name,
        surname,
        email,
        dateOfBirth,
        settings,
        coachId,
      ];
}
