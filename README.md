# Grateful: Give Thanks Daily

Grateful: Give Thanks Daily is a simple application for expressing gratitude.

## Getting started

### Build configurations

The app is structured to require separate Google Services configurations for dev and production.
Please see [this link](https://medium.com/@matt.goodson.business/separating-build-environment-configurations-in-flutter-with-firebase-doing-it-the-right-way-c72c3ad3621f) for instructions to configure Firebase. Alos, see [here](https://cogitas.net/creating-flavors-of-a-flutter-app/), [here](https://medium.com/@LohaniDamodar/flutter-separating-build-environment-with-multiple-firebase-environment-92e40e26d275), and [here](https://medium.com/@devrient.jonas/flutter-profiles-in-vscode-product-flavors-c95231818005).

#### Custom entry points

Grateful uses distinct variables for development and prod. These are specified in two different entry point files in the `lib/` directory.

In order to run a debug version of Grateful, use the command `flutter run -t lib/main_development.dart --flavor development`.

This tells flutter to run the app using `lib/main_development.dart` as the entry point, and the `development` flavor specified in `app/build.gradle`.

Likewise, to build the android app, run `flutter build apk -t lib/main_development.dart --flavor development`.

#### Build flavors
There are two build flavors described for grateful: `development` and `production`. For android, these build flavors' unique resources are specified in `android/app/src/${build_flavor}`. Any file unique to the build flavor should be defined in that directory.