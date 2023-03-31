part of firebase;

CollectionReference<UserDto> getUsersRef() {
  return FirebaseFirestore.instance.collection('Users').withConverter<UserDto>(
        fromFirestore: (snapshot, _) => UserDto.fromJson(
          snapshot.id,
          snapshot.data(),
        ),
        toFirestore: (UserDto fireUser, _) => fireUser.toJson(),
      );
}

DocumentReference<UserDto> getUserRef(String userId) {
  return getUsersRef().doc(userId);
}

DocumentReference<AppearanceSettingsDto> getAppearanceSettingsRef(
  String userId,
) {
  return getUserRef(userId)
      .collection('Settings')
      .doc('AppearanceSettings')
      .withConverter<AppearanceSettingsDto>(
        fromFirestore: (snapshot, _) => AppearanceSettingsDto.fromJson(
          userId,
          snapshot.data(),
        ),
        toFirestore: (appearanceSettings, _) => appearanceSettings.toJson(),
      );
}

DocumentReference<WorkoutSettingsDto> getWorkoutSettingsRef(
  String userId,
) {
  return getUserRef(userId)
      .collection('Settings')
      .doc('WorkoutSettings')
      .withConverter<WorkoutSettingsDto>(
        fromFirestore: (snapshot, _) => WorkoutSettingsDto.fromJson(
          userId,
          snapshot.data(),
        ),
        toFirestore: (workoutSettingsDto, _) => workoutSettingsDto.toJson(),
      );
}
