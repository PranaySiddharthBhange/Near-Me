import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geofire/Screens/Authentication%20Services/splash_screen.dart';
import 'package:geofire/Screens/Home%20Page/bottom_navigation_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen( {Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {



  var faker = Faker();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;






  Future<void> _login() async {
    String email = usernameController.text.trim();
    String password = passwordController.text.trim();
     // retrieveLocation();
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
       setState(() {
         if (userCredential.user != null) {
           _firestore.collection('users').doc(userCredential.user!.uid).set({
             'name':   faker.person.name(),
             'email': usernameController.text.toString(),
             'password': passwordController.text.toString(),
             'uid':userCredential.user!.uid.toString(),
             'latitude': latitude,
             'longitude' :longitude,
             'actual':"Actual Name",
             'profile':"https://picsum.photos/200"
             // Add more fields as needed
           });
         }
         else{
           print("Problem herre//////////////////////////////////---------------------------");
         }
       });

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BottomNavBar()),
      );
    } catch (e) {
      // Handle login error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Login Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Email",
              prefixIcon:  Icon(Icons.mail_outline),
             border: OutlineInputBorder(
               borderRadius: BorderRadius.circular(20)
             )
            ),
            controller: usernameController,),
          SizedBox(height: 50),
          TextField(
            decoration: InputDecoration(
                hintText: "Password",
                prefixIcon:  const Icon(Icons.lock_outline_rounded),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
            controller: passwordController,),
          SizedBox(height: 50),

          ElevatedButton(

            onPressed: _login,
            child: const Text("Log in"),),
        ],
      ),
    );
  }
}
