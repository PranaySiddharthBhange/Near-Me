import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Rooms%20Services/room_messages.dart';
import 'package:uuid/uuid.dart';

class SecretRooms extends StatefulWidget {

  const SecretRooms({Key? key,}) : super(key: key);

  @override
  State<SecretRooms> createState() => _SecretRoomsState();
}

class _SecretRoomsState extends State<SecretRooms> {
  TextEditingController _textEditingController = TextEditingController(); ///entree
  TextEditingController titelController2 = TextEditingController();
  TextEditingController codeController = TextEditingController();

  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Secret Rooms"),
      ),
      body: Column(
        children: [
          ElevatedButton(

              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return
                      AlertDialog(
                      title: Text('Enter Code'),
                      content: TextField(
                        controller: _textEditingController,
                        decoration:
                            InputDecoration(hintText: 'Enter code here'),
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancle'),
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                        ),
                        TextButton(
                          child: Text('Enter'),
                          onPressed: () {
                            // Handle 'Cancel' button press
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RoomMessages(docREf: _textEditingController.text.toString())));

                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text("Enter Room")),
          TextField(
            decoration: InputDecoration(
                hintText: "Title",
                prefixIcon:  Icon(Icons.chat),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
            controller: titelController2,),
          TextField(
            controller: codeController,
            onTap: (){
               setState(() {
                 codeController.text=uuid.v4().replaceAll('-', '');
               });
            },

            decoration: InputDecoration(
                hintText: "Code",
                prefixIcon:  Icon(Icons.lock),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
            ),
          ElevatedButton(onPressed: () async {

            // Get the current user's UID
             String uid = FirebaseAuth.instance.currentUser!.uid;

            // Create a document reference using the UID
            DocumentReference roomRef = FirebaseFirestore.instance.collection('rooms').doc(codeController.text.toString());

            // Create a map of the data to be stored
            await roomRef.set({
              'title':titelController2.text.toString(),
              'code':codeController.text.toString(),
              'createdBy':uid
            });



             Navigator.push(context, MaterialPageRoute(builder: (context) => RoomMessages(docREf: codeController.text.toString())));


          }, child: Text("Create Room"))
        ],
      ),
    );
  }
}
