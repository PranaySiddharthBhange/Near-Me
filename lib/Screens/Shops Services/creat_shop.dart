import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:faker/faker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geofire/Screens/Authentication%20Services/splash_screen.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:intl/intl.dart';

class CreateShop extends StatefulWidget {
  final String CollectionREf;
  const CreateShop({Key? key,required this.CollectionREf}) : super(key: key);

  @override
  State<CreateShop> createState() => _CreateShopState();
}

class _CreateShopState extends State<CreateShop> {


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


  String createdAt="Unknown";
  FirebaseAuth authred = FirebaseAuth.instance;
  User? currentUserfor;
  final titleController = TextEditingController();
  final descController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserUid();
    createdLocation();

  }

  Future<void> createdLocation() async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(latitude,longitude);
    Placemark placemark = placemarks[0];
    setState(()  {
      createdAt = '${placemark.name},${placemark.street},${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
    });

  }
  final geo = GeoFlutterFire();
  final _firestore = FirebaseFirestore.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Shop"),
      ),
      body:
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            TextField(decoration: InputDecoration(
                hintText: "Title",
                prefixIcon:  const Icon(Icons.drive_file_rename_outline),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20)
                )
            ),
              controller: titleController,),
            const SizedBox(height: 30,),
            TextField(
              decoration: InputDecoration(
                  hintText: "Description",
                  prefixIcon:  Icon(Icons.details_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              controller: descController,),
            const SizedBox(height: 30,),

            ElevatedButton(onPressed: () async {
              setState(() {
                currentUserfor=authred.currentUser;

              });
              GeoFirePoint myLocation = geo.point(latitude:latitude, longitude: longitude);
              // DocumentReference newLocationRef = await _firestore
              //     .collection(widget.CollectionREf)
              //     .add({
              //   'title': titleController.text.toString(),
              //   'position': myLocation.data,
              //   'description' : descController.text.toString(),
              //   'createdOn' : DateFormat.yMMMMd().format(DateTime.now()),
              //   'createdAt' : createdAt,
              //   'createdByName' : faker.person.name(),
              //   'createdById':uid.toString()
              //
              // });
              DocumentReference newLocationRef = await _firestore
                  .collection('shops')
                  .add({
                'title': titleController.text.toString(),
                'position': myLocation.data,
                'description' : descController.text.toString(),
                'createdOn' : DateFormat.yMMMMd().format(DateTime.now()),
                'createdAt' : createdAt,
                'createdByName' : faker.person.name(),
                'createdById':uid.toString(),
                'category':widget.CollectionREf

              });


              Navigator.pop(context);
            }, child: const Text("Create")),


          ],
        ),
      ),
    );
  }
}
