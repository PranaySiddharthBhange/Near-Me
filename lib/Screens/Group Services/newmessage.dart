import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageScreenDemo extends StatefulWidget {
  final String title;
  final String documentId;
  const MessageScreenDemo(
      {Key? key, required this.documentId, required this.title})
      : super(key: key);

  @override
  State<MessageScreenDemo> createState() => _MessageScreenDemoState();
}

class _MessageScreenDemoState extends State<MessageScreenDemo> {

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

  @override
  void initState() {
    super.initState();
    getCurrentUserUid();

  }

  Future<void> _showDeleteConfirmationDialog(String documentId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('locations')
                    .doc(widget.documentId)
                    .collection('messages')
                    .doc(documentId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }


  ScrollController _scrollController=ScrollController();
  @override
  Widget build(BuildContext context) {


    Stream<QuerySnapshot> messagesStream=FirebaseFirestore.instance.collection('locations').doc(widget.documentId).collection('messages').orderBy('time', descending: false).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
              onPressed: () async {

                DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
                    .collection('locations')
                    .doc(widget.documentId)
                    .get();


                if (documentSnapshot.exists) {
                  // Replace 'fieldName' with the name of the field you want to fetch
                  var fieldValue = documentSnapshot.get('createdById');

                  if(fieldValue==uid){
                    await FirebaseFirestore.instance
                        .collection('locations')
                        .doc(widget.documentId)
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
      Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                  physics: const BouncingScrollPhysics(),
                  controller: _scrollController,
                  shrinkWrap: true,
                  itemCount: messageDocs.length,
                  itemBuilder: (BuildContext context, int index) {

                    DocumentSnapshot messageDoc = messageDocs[index];
                    String content = messageDoc.get('content');
                    String time = messageDoc.get('time');
                    String docId=messageDoc.id;

                    return

                      GestureDetector(
                        onLongPress: (){
                          _showDeleteConfirmationDialog(docId);
                        },
                        child: Container(
                          constraints: const BoxConstraints(
                             minWidth: 50,
                            maxWidth: 100
                          ),
                        margin: const EdgeInsets.all(10),
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        decoration: BoxDecoration(border: Border.all(width: 1),
                            borderRadius: messageDoc.get('uid') == uid
                                ? const BorderRadius.only(
                                bottomRight: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))
                                : const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        child: Column(

                         crossAxisAlignment:  messageDoc.get('uid') == uid?CrossAxisAlignment.start:CrossAxisAlignment.end,
                          children: [
                            Text(content),
                            Row(
                              mainAxisAlignment:  messageDoc.get('uid') == uid?MainAxisAlignment.start:MainAxisAlignment.end,
                              children: [Text(time)],
                            )
                          ],
                        ),
                    ),
                      );

                    //   ListTile(
                    //   title: Text("Content : $content"),
                    // );
                  },
                );
              },
            ),
          ),
          
          Container(

            alignment: Alignment.bottomCenter,
            child: TextField(
              controller: messageController,
              decoration: InputDecoration(
                  hintText: "Send message",
                  suffix: IconButton(
                    onPressed: () async {

                      _scrollController.animateTo(_scrollController.position.maxScrollExtent, duration:const Duration(milliseconds: 300) , curve: Curves.easeOut);

                      await FirebaseFirestore.instance
                          .collection('locations')
                          .doc(widget.documentId)
                          .collection('messages')
                          .add({
                        'content': messageController.text.toString(),
                        'time': DateTime.now().toString(),
                        'uid': uid,
                        'location': "Nagpur"
                      });




                      // print("Current useruid ----- > $currentUid");
                      // print("Current useruid ----- > $receivedUid");
                    },
                    icon: const Icon(Icons.send),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
        ],
      ),



    );
  }
}
