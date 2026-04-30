import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Arquivo compatível com o padrão gerado pelo FlutterFire CLI.
///
/// Para usar um Firebase real, execute:
/// flutterfire configure
///
/// Depois, substitua este arquivo pelo `firebase_options.dart` gerado.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        return web;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAw0HsFX70W4n1I0w9xRyRk0TQllEUgxgg',
    appId: '1:463818841133:web:7d9d6a426df0f68962eca4',
    messagingSenderId: '463818841133',
    projectId: 'pokedex-flutter-firebase',
    authDomain: 'pokedex-flutter-firebase.firebaseapp.com',
    storageBucket: 'pokedex-flutter-firebase.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDzJQOuwnO7JyokSIdSZZwMlgNyYZ8EEA8',
    appId: '1:463818841133:android:ee43ce4b9bba89a962eca4',
    messagingSenderId: '463818841133',
    projectId: 'pokedex-flutter-firebase',
    storageBucket: 'pokedex-flutter-firebase.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'SUBSTITUA_PELO_API_KEY_IOS',
    appId: 'SUBSTITUA_PELO_APP_ID_IOS',
    messagingSenderId: 'SUBSTITUA_PELO_SENDER_ID',
    projectId: 'SUBSTITUA_PELO_PROJECT_ID',
    iosBundleId: 'com.example.pokedexFlutterFirebase',
    storageBucket: 'SUBSTITUA_PELO_PROJECT_ID.appspot.com',
  );

  static const FirebaseOptions macos = ios;

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'SUBSTITUA_PELO_API_KEY_WINDOWS',
    appId: 'SUBSTITUA_PELO_APP_ID_WINDOWS',
    messagingSenderId: 'SUBSTITUA_PELO_SENDER_ID',
    projectId: 'SUBSTITUA_PELO_PROJECT_ID',
    authDomain: 'SUBSTITUA_PELO_PROJECT_ID.firebaseapp.com',
    storageBucket: 'SUBSTITUA_PELO_PROJECT_ID.appspot.com',
  );
}