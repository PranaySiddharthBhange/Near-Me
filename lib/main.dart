import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Authentication%20Services/splash_screen.dart';

// initialize firebase
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCV6oSqUldjLWJgTvIQH1mIhqRe54HT3vY",
          authDomain: "near-me-c6971.firebaseapp.com",
          projectId: "near-me-c6971",
          storageBucket: "near-me-c6971.appspot.com",
          messagingSenderId: "125437108440",
          appId: "1:125437108440:web:fdb6e43496e072d31077ad",
          measurementId: "G-6LTDPN7MSF"
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  // await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(useMaterial3: true),
    title: "Near Me",
    home: NearMe(),
  ));
}

class NearMe extends StatelessWidget {
  const NearMe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen();
  }
}
