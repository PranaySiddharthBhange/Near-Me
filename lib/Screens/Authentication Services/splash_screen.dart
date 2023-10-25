library global.dart;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geofire/Screens/Authentication%20Services/Onboarding%20Screen/screens/login/login.dart';
import 'package:geofire/Screens/Home%20Page/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import '../Home Page/bottom_navigation_bar.dart';
import '../Group Services/group_screen.dart';
import 'Onboarding Screen/screens/onboarding/onboarding.dart';
import 'login_screen.dart';
import 'package:lottie/lottie.dart';
//stores coordinates
var latitude;
var longitude;
//authentication reference
final FirebaseAuth _auth = FirebaseAuth.instance;
User? user = _auth.currentUser;
String locationName = 'Unknown';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    //check if already login
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    //asking for location permission and store value in global variables
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
    } else {
      //high accuracy
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      //set values to variables
      latitude = position.latitude;
      longitude = position.longitude;
      //fetching location name

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      Placemark placemark = placemarks[0];

      String locationName =
          '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    }

    //checking user already login or not

    if (user != null) {
      user = _auth.currentUser;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } else {
      // final screenHeight = MediaQuery.of(context).size.height;

      Navigator.pushReplacement(
          // context, MaterialPageRoute(builder: (context) => Onboarding(screenHeight: screenHeight,)));
          context, MaterialPageRoute(builder: (context) => LoginScreen()));

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:Lottie.asset('animations/loading.json')),
    );
  }
}
