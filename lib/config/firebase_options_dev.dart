import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options_dev.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC5z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'gify-dev',
    authDomain: 'gify-dev.firebaseapp.com',
    storageBucket: 'gify-dev.appspot.com',
    measurementId: 'G-ABCDEFGHIJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC5z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'gify-dev',
    storageBucket: 'gify-dev.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC5z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'gify-dev',
    storageBucket: 'gify-dev.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC5z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'gify-dev',
    storageBucket: 'gify-dev.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC5z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9z9',
    appId: '1:123456789012:web:abcdef1234567890abcdef',
    messagingSenderId: '123456789012',
    projectId: 'gify-dev',
    storageBucket: 'gify-dev.appspot.com',
  );
}

class DefaultFirebaseOptionsDev {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBIF1bYXfUtQoevk2IGSYGAqSc-ykoGXLo",
      authDomain: "gify-dev.firebaseapp.com",
      projectId: "gify-dev",
      storageBucket: "gify-dev.firebasestorage.app",
      messagingSenderId: "272804728133",
      appId: "1:272804728133:web:6d2142128172629eec022c",
      measurementId: "G-3HDBYZV1D4",
      databaseURL: "https://gify-dev-default-rtdb.firebaseio.com/",
    );
  }
}
