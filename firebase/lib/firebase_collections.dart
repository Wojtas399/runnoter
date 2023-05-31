import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/appearance_settings_dto.dart';
import 'model/blood_test_dto.dart';
import 'model/health_measurement_dto.dart';
import 'model/user_dto.dart';
import 'model/workout_dto.dart';
import 'model/workout_settings_dto.dart';

CollectionReference<UserDto> getUsersRef() =>
    FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
          fromFirestore: (snapshot, _) => UserDto.fromJson(
            snapshot.id,
            snapshot.data(),
          ),
          toFirestore: (UserDto userDto, _) => userDto.toJson(),
        );

DocumentReference<UserDto> getUserRef(
  String userId,
) =>
    getUsersRef().doc(userId);

CollectionReference<WorkoutDto> getWorkoutsRef(
  String userId,
) =>
    getUserRef(userId).collection('Workouts').withConverter<WorkoutDto>(
          fromFirestore: (snapshot, _) => WorkoutDto.fromJson(
            docId: snapshot.id,
            userId: userId,
            json: snapshot.data(),
          ),
          toFirestore: (workoutDto, _) => workoutDto.toJson(),
        );

CollectionReference<HealthMeasurementDto> getHealthMeasurementsRef(
  String userId,
) =>
    getUserRef(userId)
        .collection('HealthMeasurements')
        .withConverter<HealthMeasurementDto>(
          fromFirestore: (snapshot, _) => HealthMeasurementDto.fromJson(
            userId: userId,
            dateStr: snapshot.id,
            json: snapshot.data(),
          ),
          toFirestore: (healthMeasurementDto, _) =>
              healthMeasurementDto.toJson(),
        );

DocumentReference<AppearanceSettingsDto> getAppearanceSettingsRef(
  String userId,
) =>
    getUserRef(userId)
        .collection('Settings')
        .doc('AppearanceSettings')
        .withConverter<AppearanceSettingsDto>(
          fromFirestore: (snapshot, _) => AppearanceSettingsDto.fromJson(
            userId,
            snapshot.data(),
          ),
          toFirestore: (appearanceSettingsDto, _) =>
              appearanceSettingsDto.toJson(),
        );

DocumentReference<WorkoutSettingsDto> getWorkoutSettingsRef(
  String userId,
) =>
    getUserRef(userId)
        .collection('Settings')
        .doc('WorkoutSettings')
        .withConverter<WorkoutSettingsDto>(
          fromFirestore: (snapshot, _) => WorkoutSettingsDto.fromJson(
            userId,
            snapshot.data(),
          ),
          toFirestore: (workoutSettingsDto, _) => workoutSettingsDto.toJson(),
        );

CollectionReference<BloodTestDto> getBloodTestsRef(
  String userId,
) =>
    getUserRef(userId).collection('BloodTests').withConverter<BloodTestDto>(
          fromFirestore: (snapshot, _) => BloodTestDto.fromJson(
            id: snapshot.id,
            userId: userId,
            json: snapshot.data(),
          ),
          toFirestore: (bloodTestsDto, _) => bloodTestsDto.toJson(),
        );
