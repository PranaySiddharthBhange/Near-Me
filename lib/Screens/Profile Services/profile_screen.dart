import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Blood%20Services/blood_screen.dart';
import 'package:geofire/Screens/Profile%20Services/my_groups.dart';
import 'package:geofire/Screens/Profile%20Services/my_rooms.dart';
import 'package:geofire/Screens/Profile%20Services/my_shop.dart';
import 'package:image_picker/image_picker.dart';
import '../Authentication Services/login_screen.dart';
class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {




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




  Future<void> pickImageAndUpload() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {

    }
  }


  @override
  Widget build(BuildContext context) {

    CollectionReference<Map<String, dynamic>> collection =
    FirebaseFirestore.instance.collection('users');


    TextEditingController _textEditingController=TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body:  Column(
       children: [

         Expanded(child:

         StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
           stream: collection.where('uid', isEqualTo: createdBy).snapshots(),
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
                       CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(data?['profile'] ),
                       ),
                       Text(data?['actual']),
                       Text(data?['name']),
                       Text(data?['email']),
                     ],
                   ),
                   // Add other fields as needed
                 );
               }).toList(),
             );
           },
         )


        ),
         TextButton(onPressed: () async {

           showDialog(
             context: context,
             builder: (BuildContext context) {
               return
                 AlertDialog(

                   title: const Text('Edit Profile'),
                   content: Column(
                     children: [
                       IconButton(onPressed: (){
                         setState(() {
                           pickImageAndUpload();

                         });
                       }, icon: const Icon(Icons.image,size: 50,)),
                       TextField(
                         controller: _textEditingController,
                         decoration:
                         const InputDecoration(hintText: 'Enter New here'),
                       ),
                     ],
                   ),
                   actions: [
                     TextButton(
                       child: const Text('Cancle'),
                       onPressed: () {
                         Navigator.of(context).pop(); // Close the dialog
                       },
                     ),
                     TextButton(
                       child: const Text('Ok'),
                       onPressed: () {

                       },
                     ),
                   ],
                 );
             },
           );

         }, child: const Text("Edit")),

         TextButton(onPressed: () async {

           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => BloodCategories()),
           );
         }, child: const Text("Blood")),

         TextButton(onPressed: () async {

           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MyShop()),
           );
         }, child: const Text("My Shops")),
         TextButton(onPressed: () async {

           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MyGroups()),
           );
         }, child: const Text("My Groups")),
         TextButton(onPressed: () async {

           Navigator.pushReplacement(
             context,
             MaterialPageRoute(builder: (context) => MyRooms()),
           );
         }, child: const Text("My Rooms")),

       TextButton(onPressed: () async {
         await FirebaseAuth.instance.signOut();

         Navigator.pushReplacement(
           context,
           MaterialPageRoute(builder: (context) => LoginScreen()),
         );
       }, child: const Text("Logout"))
       ],
        )
    );
  }
}
