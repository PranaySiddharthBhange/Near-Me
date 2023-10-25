import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyRooms extends StatefulWidget {
  const MyRooms({Key? key}) : super(key: key);

  @override
  State<MyRooms> createState() => _MyRoomsState();
}

class _MyRoomsState extends State<MyRooms> {

  CollectionReference<Map<String, dynamic>> locationCollection =
  FirebaseFirestore.instance.collection('rooms');
  String? createdBy;
  void getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      setState(() {
        this.createdBy = uid;
      });
      print('User UID: $uid');
    } else {
      setState(() {
        this.createdBy = null;
      });
      print('======================================>>>>>>>>>>>>No user currently logged in.');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserUid();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Groups"),
      ),
      body:  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: locationCollection.where('createdBy', isEqualTo: createdBy).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return const Text('No matching documents found.');
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot<Map<String, dynamic>> document) {
              final data = document.data();
              // Access and display the fields here
              return ListTile(
                title: Column(
                  children: [

                    Text(data?['title']),
                    Text(data?['code']),

                  ],
                ),
                // Add other fields as needed
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
