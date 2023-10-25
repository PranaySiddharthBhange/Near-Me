import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomMessages extends StatefulWidget {
  final String docREf;
  const RoomMessages({Key? key,required this.docREf}) : super(key: key);


  @override
  State<RoomMessages> createState() => _RoomMessagesState();
}

class _RoomMessagesState extends State<RoomMessages> {
  String title='';
  String code='';
  String fetcheduid='';

  var currentUid = '';
  var receivedUid = '';

  final messageController = TextEditingController();

  String? uid;
  void getCurrentUserUid() {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      String uid = user.uid;
      setState(() {
        this.uid = uid;
      });
      print('User UID: $uid');
    } else {
      setState(() {
        this.uid = null;
      });
      print('======================================>>>>>>>>>>>>No user currently logged in.');
    }
  }



  Future<void> fetchFields() async {

      DocumentReference docRef = FirebaseFirestore.instance.collection('rooms').doc(widget.docREf);

      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {

        setState(() {
          title = docSnapshot.get('title');
          code = docSnapshot.get('code');
          fetcheduid=docSnapshot.get('createdBy');

        });

        // Perform any necessary operations with the retrieved fields
        print('Title: $title');
        print('Code: $code');
        print('fetched $fetcheduid');
      } else {
        print('Document does not exist');
      }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      fetchFields();
      getCurrentUserUid();
  }

  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot> messagesStream=FirebaseFirestore.instance.collection('rooms')
        .doc(widget.docREf)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(title.toString()),
        actions: [
          IconButton(
              onPressed: () async {

                DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(widget.docREf)
                    .get();


                if (documentSnapshot.exists) {
                  // Replace 'fieldName' with the name of the field you want to fetch
                  var fieldValue = documentSnapshot.get('createdById');

                  if(fieldValue==uid){
                    await FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(widget.docREf)
                        .delete();
                    Navigator.pop(context);

                  }
                  else{
                    Fluttertoast.showToast(
                        msg: 'You are not the admin',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.red,
                        textColor: Colors.white);
                  }
                  print('-----------------------------------------------Field Value: $fieldValue');
                } else {
                  print('Document does not exist');
                }


              }, icon: const Icon(Icons.delete_outline)),
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.keyboard_arrow_right))
        ],
      ),

      body:
      SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 620,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [

                    StreamBuilder<QuerySnapshot>(
                      stream: messagesStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        if (snapshot.data!.docs.isEmpty) {
                          return const Text('No message found');
                        }

                        List<QueryDocumentSnapshot> messageDocs = snapshot.data!.docs;

                        return ListView.builder(
                          shrinkWrap: true,
                          itemCount: messageDocs.length,
                          itemBuilder: (BuildContext context, int index) {

                            DocumentSnapshot messageDoc = messageDocs[index];
                            String content = messageDoc.get('content');
                            String time = messageDoc.get('time');
                            receivedUid = messageDoc.get('uid');

                            return Container(
                              margin: const EdgeInsets.all(10),
                              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                              constraints: const BoxConstraints(
                                minWidth: 10, // Minimum width of the container
                                maxWidth: 100, // Maximum width of the container
                              ),
                              decoration: BoxDecoration(
                                  border: Border.all(width: 1),
                                  borderRadius: receivedUid == currentUid
                                      ? const BorderRadius.only(
                                      bottomRight: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))
                                      : const BorderRadius.only(
                                      bottomLeft: Radius.circular(20),
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child: Column(
                                children: [
                                  Text(content),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [Text(time)],
                                  )
                                ],
                              ),
                            );

                            //   ListTile(
                            //   title: Text("Content : $content"),
                            // );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                  hintText: "Send message",
                  suffix: IconButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('rooms')
                          .doc(widget.docREf)
                          .collection('messages')
                          .add({
                        'content': messageController.text.toString(),
                        'time': DateTime.now().toString(),
                        'uid': uid,

                      });

                      // print("Current useruid ----- > $currentUid");
                      // print("Current useruid ----- > $receivedUid");
                    },
                    icon: const Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ],
        ),
      ),


    );
  }
}
