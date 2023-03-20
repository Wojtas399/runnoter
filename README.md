![logo](https://user-images.githubusercontent.com/72093398/226473308-a2d23071-51c7-4aaf-b0f7-4565b75d7fd2.png)

# Table of contents

- [Description](#description)
- [Features](#features)
- [UI Design](#ui-design)
- [Installation & run process](#installation--run-process)

# Description

Runnoter is an app which helps you manage your running plan. Using this app you can schedule
running workouts and competitions, manage status and result of scheduled workouts,
follow progress of mileage or weight and store blood test results.

# Features

- User-friendly interface
- Light/Dark mode
- Polish/English language
- Offline mode
- Statistics
- Calendar

# UI Design

Below is the link to Runnoter UI design in Figma:

```
https://www.figma.com/file/DG4wmTQ7OwM4gTJgZl8Q1T/Runnoter?t=xIdpS8SoBwO0NuWf-1
```

# Installation & run process

To be able to run the app you have to do below steps:

1. <b>Install Dart & Flutter</b> <br/>
   First of all, you have to install Dart and Flutter. Below are links to official docs where you can find instructions
   about installation process:

   Dart:
    ```
    https://dart.dev/get-dart
    ```
   Flutter:
    ```
    https://docs.flutter.dev/get-started/install
    ```

2. <b>Create Firebase project</b> <br/>
   This app uses Firebase as a database platform, so you have to create Firebase project and connect it to the app. Below is the link to official docs:
    ```
    https://firebase.google.com/docs/flutter/setup?platform=ios
    ```
   The command ```flutterfire configure``` should do all required work for you. It should configure selected platforms
   and create all required files.

3. <b>Install dependencies and additional files</b> <br/>
   To do so, you can use derry package which do all required work for you. You have to activate derry using below
   command:
    ```
   dart pub global activate derry
   ```
   Then you just have to run:
    ```
    derry install
   ```
4. <b>Run app</b> <br/>
   To run an app you have to run emulator or connect physical device and then call:

   ```
   flutter run
   ```
If you have any troubles with installation process, below is link to the official docs:
```
https://docs.flutter.dev/get-started/install
```
