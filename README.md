![logo](https://user-images.githubusercontent.com/72093398/226473308-a2d23071-51c7-4aaf-b0f7-4565b75d7fd2.png)

# Table of contents

- [Description](#description)
- [Features](#features)
- [UI Design](#ui-design)
- [Installation & run process](#installation--run-process)
- [Screenshots](#screenshots)

# Description

Runnoter is an app which helps you manage your running plan. Using this app you can schedule
running workouts and races, manage status and result of scheduled workouts,
follow progress of mileage or weight and store blood test results. You can also use this app in coach mode which allows you to create your own client network.

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
<img width="300" alt="lightCalendarWeek" src="https://github.com/Wojtas399/runnoter/assets/72093398/57b13271-eab5-4b26-82df-01fb83a1149d"><img width="300" alt="darkCalendarWeek" src="https://github.com/Wojtas399/runnoter/assets/72093398/1f5dba33-aff7-4801-8864-eaa58d3ae528">

<img width="300" alt="lightCalendarMonth" src="https://github.com/Wojtas399/runnoter/assets/72093398/d54078cf-3d96-477a-b747-a400aecc1052"><img width="300" alt="darkCalendarMonth" src="https://github.com/Wojtas399/runnoter/assets/72093398/6323c07f-8fa0-4c19-beab-976b09f41dc0">

<img width="300" alt="lightWorkoutPreview" src="https://github.com/Wojtas399/runnoter/assets/72093398/58031c8b-1195-433d-a28c-84fd40ed9f14"><img width="300" alt="darkWorkoutPreview" src="https://github.com/Wojtas399/runnoter/assets/72093398/fa423723-59c3-4f3f-8d07-aa043fa362b3">

<img width="300" alt="lightHealth" src="https://github.com/Wojtas399/runnoter/assets/72093398/4f73651d-cd87-4b52-9090-77d3e8059685"><img width="300" alt="darkHealth" src="https://github.com/Wojtas399/runnoter/assets/72093398/fa132814-6143-4087-9960-8b5880459e6f">

<img width="300" alt="lightBloodTests" src="https://github.com/Wojtas399/runnoter/assets/72093398/a2e1d366-8889-4d29-8540-f80a3ef18c21"><img width="300" alt="darkBloodTests" src="https://github.com/Wojtas399/runnoter/assets/72093398/43d37dc2-9ee2-4ce2-8dd5-85f748544609">

<img width="300" alt="lightRaces" src="https://github.com/Wojtas399/runnoter/assets/72093398/cd15e56e-e74c-41f0-b071-2027f6f62f49"><img width="300" alt="darkRaces" src="https://github.com/Wojtas399/runnoter/assets/72093398/a72ad4db-f5c6-49ac-9655-4c0d029d5da2">

<img width="1840" alt="webCalendarWeek" src="https://github.com/Wojtas399/runnoter/assets/72093398/9ce956c6-e7c2-4483-b566-20aedab92e9b">
<img width="1840" alt="webCalendarMonth" src="https://github.com/Wojtas399/runnoter/assets/72093398/408830bd-88ce-41fb-bb1f-906d508b0279">
<img width="1840" alt="webHealth" src="https://github.com/Wojtas399/runnoter/assets/72093398/89d30f20-f14e-4a7e-aba7-c8965222b109">
