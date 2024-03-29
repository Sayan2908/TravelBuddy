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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDQ1hx1hVv6AiUD8txd4Zlklb7OAcMBw5E',
    appId: '1:8666627281:web:86d222c45cc5e8575819f0',
    messagingSenderId: '8666627281',
    projectId: 'travel-buddy-dcb30',
    authDomain: 'travel-buddy-dcb30.firebaseapp.com',
    storageBucket: 'travel-buddy-dcb30.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA9TfNvR-Q6velronqqUDkQmOIX-u4Cxpw',
    appId: '1:8666627281:android:480f5b801b7ef8a85819f0',
    messagingSenderId: '8666627281',
    projectId: 'travel-buddy-dcb30',
    storageBucket: 'travel-buddy-dcb30.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCq4XtZWB7pi_v8bd0PVttdGtwsSVpG7ew',
    appId: '1:8666627281:ios:c5c8828ff89c35a75819f0',
    messagingSenderId: '8666627281',
    projectId: 'travel-buddy-dcb30',
    storageBucket: 'travel-buddy-dcb30.appspot.com',
    androidClientId: '8666627281-fdagnjceqhqgmhf7h3r9jno0146snfvc.apps.googleusercontent.com',
    iosClientId: '8666627281-v8e7nu73aulluhrkchnrch8gmjna1mhm.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelChecklist',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCq4XtZWB7pi_v8bd0PVttdGtwsSVpG7ew',
    appId: '1:8666627281:ios:1b59c44794144c885819f0',
    messagingSenderId: '8666627281',
    projectId: 'travel-buddy-dcb30',
    storageBucket: 'travel-buddy-dcb30.appspot.com',
    androidClientId: '8666627281-fdagnjceqhqgmhf7h3r9jno0146snfvc.apps.googleusercontent.com',
    iosClientId: '8666627281-errctq2c7jaa8jeqep4j78vt860qcla0.apps.googleusercontent.com',
    iosBundleId: 'com.example.travelChecklist.RunnerTests',
  );
}
