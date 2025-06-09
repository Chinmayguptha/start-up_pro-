import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDg6QP2FBWAp0sxqegB40k1pTnw_c-kDng',
    appId: '1:411870907427:web:dd9fc217351d0895333596',
    messagingSenderId: '411870907427',
    projectId: 'startuphubapp',
    authDomain: 'startuphubapp.firebaseapp.com',
    storageBucket: 'startuphubapp.firebasestorage.app',
    measurementId: 'G-2EYBERMXQH',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDg6QP2FBWAp0sxqegB40k1pTnw_c-kDng',
    appId: '1:411870907427:android:dd9fc217351d0895333596',
    messagingSenderId: '411870907427',
    projectId: 'startuphubapp',
    storageBucket: 'startuphubapp.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDg6QP2FBWAp0sxqegB40k1pTnw_c-kDng',
    appId: '1:411870907427:ios:dd9fc217351d0895333596',
    messagingSenderId: '411870907427',
    projectId: 'startuphubapp',
    storageBucket: 'startuphubapp.firebasestorage.app',
    iosClientId: '411870907427-ios-client-id',
    iosBundleId: 'com.example.pppprrrjjjcccttt',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDg6QP2FBWAp0sxqegB40k1pTnw_c-kDng',
    appId: '1:411870907427:macos:dd9fc217351d0895333596',
    messagingSenderId: '411870907427',
    projectId: 'startuphubapp',
    storageBucket: 'startuphubapp.firebasestorage.app',
    iosClientId: '411870907427-macos-client-id',
    iosBundleId: 'com.example.pppprrrjjjcccttt',
  );
} 