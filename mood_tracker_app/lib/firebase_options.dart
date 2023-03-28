// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA57uuQLREvstM_rWTYJWT8q5Us8jiL35c',
    appId: '1:150281157525:android:2b34c0378d51777316949c',
    messagingSenderId: '150281157525',
    projectId: 'meliora-tracker',
    databaseURL: 'https://meliora-tracker-default-rtdb.firebaseio.com',
    storageBucket: 'meliora-tracker.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBYMmhiulo0qjOTwymsOhqeTyxxVtQ_57E',
    appId: '1:150281157525:ios:1b494effc1789e4a16949c',
    messagingSenderId: '150281157525',
    projectId: 'meliora-tracker',
    databaseURL: 'https://meliora-tracker-default-rtdb.firebaseio.com',
    storageBucket: 'meliora-tracker.appspot.com',
    iosClientId: '150281157525-efct2bhd96ua70n9293sssd83jgts3u8.apps.googleusercontent.com',
    iosBundleId: 'com.example.moodTrackerApp',
  );
}
