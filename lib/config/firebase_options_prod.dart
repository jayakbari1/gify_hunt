import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Production [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_prod.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptionsProd.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptionsProd {
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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptionsProd have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptionsProd are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDKl3cYWYMRtYDf_DueDAxmL-5a_sgbiO0',
    appId: '1:1077207578725:web:40e4299f8a46ac96c02e8c',
    messagingSenderId: '1077207578725',
    projectId: 'gify-marketplace',
    authDomain: 'gify-marketplace.firebaseapp.com',
    storageBucket: 'gify-marketplace.firebasestorage.app',
    measurementId: 'G-22KNB12DJB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDKl3cYWYMRtYDf_DueDAxmL-5a_sgbiO0',
    appId: '1:1077207578725:web:40e4299f8a46ac96c02e8c',
    messagingSenderId: '1077207578725',
    projectId: 'gify-marketplace',
    storageBucket: 'gify-marketplace.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDKl3cYWYMRtYDf_DueDAxmL-5a_sgbiO0',
    appId: '1:1077207578725:web:40e4299f8a46ac96c02e8c',
    messagingSenderId: '1077207578725',
    projectId: 'gify-marketplace',
    storageBucket: 'gify-marketplace.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDKl3cYWYMRtYDf_DueDAxmL-5a_sgbiO0',
    appId: '1:1077207578725:web:40e4299f8a46ac96c02e8c',
    messagingSenderId: '1077207578725',
    projectId: 'gify-marketplace',
    storageBucket: 'gify-marketplace.firebasestorage.app',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDKl3cYWYMRtYDf_DueDAxmL-5a_sgbiO0',
    appId: '1:1077207578725:web:40e4299f8a46ac96c02e8c',
    messagingSenderId: '1077207578725',
    projectId: 'gify-marketplace',
    storageBucket: 'gify-marketplace.firebasestorage.app',
  );
}

