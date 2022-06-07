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
    apiKey: 'AIzaSyAGPK3MDYtEFSMoYvJI-NPDHg9pa8pi9Ik',
    appId: '1:822424801182:android:2dbf97aebb9081853c908f',
    messagingSenderId: '822424801182',
    projectId: 'flutter-complete-guide-51951',
    databaseURL: 'https://flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-complete-guide-51951.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA6b27rrh6Pm6VQlOGsDgbkWr-zK2jFJBc',
    appId: '1:822424801182:ios:af10b3ccc3e1fee23c908f',
    messagingSenderId: '822424801182',
    projectId: 'flutter-complete-guide-51951',
    databaseURL: 'https://flutter-complete-guide-51951-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'flutter-complete-guide-51951.appspot.com',
    iosClientId: '822424801182-eh1ulcvmlo9o2q8lh36506g5hp13egu2.apps.googleusercontent.com',
    iosBundleId: 'com.example.flutterCompleteGuide',
  );
}
