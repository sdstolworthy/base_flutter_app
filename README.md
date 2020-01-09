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
