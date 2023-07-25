![logo](https://user-images.githubusercontent.com/72093398/226473308-a2d23071-51c7-4aaf-b0f7-4565b75d7fd2.png)

# Table of contents

- [Description](#description)
- [Features](#features)
- [UI Design](#ui-design)
- [Installation & run process](#installation--run-process)
- [Screenshots](#screenshots)

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
# Screenshots
<img width="300" alt="lightCurrentWeek" src="https://github.com/Wojtas399/runnoter/assets/72093398/b37467e5-5ae4-4f74-b65d-e6684a611055.png"><img width="300" alt="darkCurrentWeek" src="https://github.com/Wojtas399/runnoter/assets/72093398/a7a8fcb0-8af8-4d70-93d3-3c15f2576027.png">

<img width="300" alt="lightWorkoutPreview" src="https://github.com/Wojtas399/runnoter/assets/72093398/58031c8b-1195-433d-a28c-84fd40ed9f14.png"><img width="300" alt="darkWorkoutPreview" src="https://github.com/Wojtas399/runnoter/assets/72093398/fa423723-59c3-4f3f-8d07-aa043fa362b3.png">


<img width="300" alt="lightCalendar" src="https://github.com/Wojtas399/runnoter/assets/72093398/6b4df555-176e-49a8-ac89-eab30f6eb5ab.png"><img width="300" alt="darkCalendar" src="https://github.com/Wojtas399/runnoter/assets/72093398/902b62bf-2773-48b2-9456-4b7edf26caaf.png">

<img width="300" alt="lightHealth" src="https://github.com/Wojtas399/runnoter/assets/72093398/7e73ea7c-575f-41e6-8923-1d112f89b8d8.png"><img width="300" alt="darkHealth" src="https://github.com/Wojtas399/runnoter/assets/72093398/31730b26-0dc0-4b67-a4f4-e13832ec1544.png">

<img width="300" alt="lightBloodTests" src="https://github.com/Wojtas399/runnoter/assets/72093398/10e3aaea-08bb-4cde-bf80-6e8ecbc13d29.png"><img width="300" alt="darkBloodTests" src="https://github.com/Wojtas399/runnoter/assets/72093398/cb8bd32d-e020-42e8-a5b4-ea791dea1a45">

<img width="300" alt="lightRaces" src="https://github.com/Wojtas399/runnoter/assets/72093398/40d14c41-e1ac-4edc-9b70-75f72bb550b1.png"><img width="300" alt="darkRaces" src="https://github.com/Wojtas399/runnoter/assets/72093398/7c7adb2c-4792-476a-9ccd-7195bde7bc90.png">

<img width="1840" alt="webCurrentWeek" src="https://github.com/Wojtas399/runnoter/assets/72093398/6c500a69-b610-4e45-a70c-fcbb012344da">
<img width="1840" alt="webCalendar" src="https://github.com/Wojtas399/runnoter/assets/72093398/b4b2cff5-f4bd-4577-b520-010e4c2e1bdc">
<img width="1840" alt="webHealth" src="https://github.com/Wojtas399/runnoter/assets/72093398/23ea0099-1afa-4ea7-a40b-7832fcb57cc4">
