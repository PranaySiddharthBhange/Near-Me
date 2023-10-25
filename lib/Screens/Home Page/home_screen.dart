import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Group%20Services/group_screen.dart';
import 'package:geofire/Screens/Profile%20Services/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          children: [
            Icon(
              Icons.near_me_outlined,
              size: 25,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Near Me',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(),));
            }, icon: Icon(Icons.account_circle,color: Colors.black,)),
          ),

        ],
      ),
    );
  }
}
