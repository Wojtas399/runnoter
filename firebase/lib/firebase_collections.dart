import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase.dart';

CollectionReference<UserDto> getUsersRef() =>
    FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
          fromFirestore: (snapshot, _) => UserDto.fromJson(
            userId: snapshot.id,
            json: snapshot.data(),
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
            workoutId: snapshot.id,
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

//TODO: Change it to Appearance instead of AppearanceSettings
DocumentReference<AppearanceSettingsDto> getAppearanceSettingsRef(
  String userId,
) =>
    getUserRef(userId)
        .collection('Settings')
        .doc('AppearanceSettings')
        .withConverter<AppearanceSettingsDto>(
          fromFirestore: (snapshot, _) => AppearanceSettingsDto.fromJson(
            userId: userId,
            json: snapshot.data(),
          ),
          toFirestore: (appearanceSettingsDto, _) =>
              appearanceSettingsDto.toJson(),
        );

//TODO: Change it to Activities instead of ActivitiesSettings
DocumentReference<ActivitiesSettingsDto> getActivitiesSettingsRef(
  String userId,
) =>
    getUserRef(userId)
        .collection('Settings')
        .doc('ActivitiesSettings')
        .withConverter<ActivitiesSettingsDto>(
          fromFirestore: (snapshot, _) => ActivitiesSettingsDto.fromJson(
            userId: userId,
            json: snapshot.data(),
          ),
          toFirestore: (activitiesSettingsDto, _) =>
              activitiesSettingsDto.toJson(),
        );

CollectionReference<BloodTestDto> getBloodTestsRef(
  String userId,
) =>
    getUserRef(userId).collection('BloodTests').withConverter<BloodTestDto>(
          fromFirestore: (snapshot, _) => BloodTestDto.fromJson(
            bloodTestId: snapshot.id,
            userId: userId,
            json: snapshot.data(),
          ),
          toFirestore: (bloodTestsDto, _) => bloodTestsDto.toJson(),
        );

CollectionReference<RaceDto> getRacesRef(
  String userId,
) =>
    getUserRef(userId).collection('Races').withConverter<RaceDto>(
          fromFirestore: (snapshot, _) => RaceDto.fromJson(
            raceId: snapshot.id,
            userId: userId,
            json: snapshot.data(),
          ),
          toFirestore: (competitionDto, _) => competitionDto.toJson(),
        );

CollectionReference<InvitationDto> getInvitationsRef() =>
    FirebaseFirestore.instance
        .collection('Invitations')
        .withConverter<InvitationDto>(
          fromFirestore: (snapshot, _) => InvitationDto.fromJson(
            invitationId: snapshot.id,
            json: snapshot.data(),
          ),
          toFirestore: (invitationDto, _) => invitationDto.toJson(),
        );
