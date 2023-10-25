import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Working%20Services/work_gallery.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerInformation extends StatefulWidget {
  final String title;
  final String documentId;
  const WorkerInformation(
      {Key? key, required this.title, required this.documentId})
      : super(key: key);

  @override
  State<WorkerInformation> createState() => _WorkerInformationState();
}

class _WorkerInformationState extends State<WorkerInformation> {

  Future<void> fetchData() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('workers')
        .doc(widget.documentId)
        .get();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:
      StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('workers')
            .doc(widget.documentId)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Text('Document does not exist');
          }

          var data = snapshot.data!;          // Display the data or perform further processing
          return

            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    data.get('image'),
                    fit: BoxFit.cover,
                  ),
                ),
                  SizedBox(
                    height: 30,
                  ),
                Text(data.get('summary')),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: (){
                        var whatsappUrl =
                            "whatsapp://send?phone=${'+91'+data.get('whatsapp')}" +
                                "&text=${Uri.encodeComponent("Hello")}";
                        launch(whatsappUrl);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(15),
                            width:
                            60, // Set the width to occupy the entire available space
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 9,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/1383/1383269.png')),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        await launch("tel://+91"+data.get('mobnumber'));

                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            padding: const EdgeInsets.all(8),
                            margin: const EdgeInsets.all(15),
                            width:
                            60, // Set the width to occupy the entire available space
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.4),
                                  spreadRadius: 5,
                                  blurRadius: 9,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/2593/2593514.png')),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        child: FloatingActionButton(
                          onPressed: () {

                            Navigator.push(context, MaterialPageRoute(builder: (context) => WorkGallery(docId: widget.documentId,),));
                          },
                          backgroundColor: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                                'https://cdn-icons-png.flaticon.com/128/1925/1925215.png'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
            ;
        },
      ),




    );
  }
}
