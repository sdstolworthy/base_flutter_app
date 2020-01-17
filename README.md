# Flutter Base App

The flutter base app is a starter Flutter app that includes many features common in all apps.

The app provides several generic widgets and features to get you started, including:

- Internationalization
- Welcome and Login screens
- Firebase plugins
- Generic Item Feed
- Generic Item Edit/Create widgets
- Bloc state management
- Theming
- [COMING SOON] Push notifications

## Up and Running

To get started, clone or fork the repository.

To configure Firebase, the instructions here: [Firebase Installation instructions](https://dashboard.heroku.com/apps/di-integrations).

### Build configurations

The app is structured to require separate Google Services configurations for dev and production.
Please see [this link](https://medium.com/@matt.goodson.business/separating-build-environment-configurations-in-flutter-with-firebase-doing-it-the-right-way-c72c3ad3621f) for instructions to configure Firebase. Also, see [here](https://cogitas.net/creating-flavors-of-a-flutter-app/), [here](https://medium.com/@LohaniDamodar/flutter-separating-build-environment-with-multiple-firebase-environment-92e40e26d275), and [here](https://medium.com/@devrient.jonas/flutter-profiles-in-vscode-product-flavors-c95231818005).

#### Firing up Firebase

It is a good idea to keep development and production environments separate. If you use Firebase services, you should create two separate projects, one for production and one for development. The two google-services.json files should be placed in the `android/app/src/${environment}` folder. When the app is compiled, the file that belongs to each build environment will be included in the product. Thus, you can maintain separate datastores and user lists for each environment.

**iOS directions for build flavors forthcoming**

#### Custom entry points

Grateful uses distinct variables for development and prod. These are specified in two different entry point files in the `lib/` directory.

In order to run a debug version of Grateful, use the command `flutter run -t lib/main_development.dart --flavor development`.

This tells flutter to run the app using `lib/main_development.dart` as the entry point, and the `development` flavor specified in `app/build.gradle`.

Likewise, to build the android app, run `flutter build apk -t lib/main_development.dart --flavor development`.

#### Build flavors
There are two build flavors described for grateful: `development` and `production`. For android, these build flavors' unique resources are specified in `android/app/src/${build_flavor}`. Any file unique to the build flavor should be defined in that directory.

**Important**
The app will not compile if you have not configured Firebase for the target platform (iOS or Android).

## Structure

### Screens

Screens are the major logical divisions of the app. They tie together state and presentation. Screens are located in `src/lib/screens`

### Routes

Routing is handled by a single navigator.
The navigator is located in `src/services/navigator.dart`.
Routes are located in `src/services/routes.dart`.

### Repositories

The repositories wrap network requests. They are located in `src/services/repositories`.

## Theming

The theme is located in `src/lib/theme`. The theme is a light wrapper around the Material theme. The routes are already set up to correctly inherit from the theme in the theme folder.
