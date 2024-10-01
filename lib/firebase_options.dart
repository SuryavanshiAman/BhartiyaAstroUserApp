import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;

      default:
        return android;
    }
  }

  
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: "AIzaSyDHP77oq5jt_MVCM_zSMO25a5ix0oMkT-0",
    authDomain: "bharatiya-astro-astrologer.firebaseapp.com",//
    projectId: "bharatiya-astro-astrologer",
    storageBucket: "bharatiya-astro-astrologer.appspot.com",
    messagingSenderId: "451161341533",//
    appId: "1:451161341533:android:d1e004fe592bbf27a717b4",//
    //measurementId: "G-KBPRBBZRYC",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: "AIzaSyBqN3StK3tU4VWcswAZBKbvff3wZA2qKEU",
    authDomain: "BharatiyAstro-75d26.firebaseapp.com",
    projectId: "BharatiyAstro-75d26",
    storageBucket: "BharatiyAstro-75d26.appspot.com",
    messagingSenderId: "665794319149",
    appId: "1:665794319149:ios:ac01bea76103ccf108b9a4",
    androidClientId:'665794319149-02oh4re817htjn9jv6j6jcv8m7priiri.apps.googleusercontent.com',
    iosClientId:'665794319149-3mni5ojukktfr9riv3gg90uahj7e5k6b.apps.googleusercontent.com',
    iosBundleId: 'com.os.BharatiyAstro.app',
    //measurementId: "G-KBPRBBZRYC",
  );
}
