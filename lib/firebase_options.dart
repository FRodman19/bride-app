// File generated based on google-services.json
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyDRLb9Mlg0cOIegPQzF9JpkwEx0nmWypYw',
    appId: '1:308216823840:android:88d2734f356bf9c9e2bc45',
    messagingSenderId: '308216823840',
    projectId: 'bride-578de',
    storageBucket: 'bride-578de.firebasestorage.app',
  );

  // TODO: Replace with actual iOS config from GoogleService-Info.plist
  // For now using Android config as placeholder - iOS will fail until configured
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDRLb9Mlg0cOIegPQzF9JpkwEx0nmWypYw',
    appId: '1:308216823840:android:88d2734f356bf9c9e2bc45',
    messagingSenderId: '308216823840',
    projectId: 'bride-578de',
    storageBucket: 'bride-578de.firebasestorage.app',
    iosBundleId: 'com.growoutloud.brideapp',
  );
}
