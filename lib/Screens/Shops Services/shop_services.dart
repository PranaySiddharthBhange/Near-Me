import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Shops%20Services/creat_shop.dart';
import 'package:geofire/Screens/Shops%20Services/shop_categories.dart';
import 'package:geofire/Screens/Shops%20Services/shopMap.dart';
import 'package:geofire/Screens/Shops%20Services/shop_messages.dart';
import 'package:geofire/Screens/Authentication%20Services/splash_screen.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:units_converter/models/extension_converter.dart';
import 'package:units_converter/properties/length.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceScreen extends StatefulWidget {
  final Category category;

  const ServiceScreen({Key? key, required this.category}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
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
      print(
          '======================================>>>>>>>>>>>>No user currently logged in.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUserUid();
  }

  double radius = 0.0;
  Timer? _timer;
  bool _longPressCancled = false;

  void _increaseRadius() {
    setState(() {
      radius++;
    });
  }

  void _decreaseRadius() {
    setState(() {
      radius--;
    });
  }

  void _cancleIncrement() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _longPressCancled = true;
  }

  void openGoogleMaps(double latitude, double longitude) async {
    final String googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw 'Could not open Google Maps.';
    }
  }


  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final geo = GeoFlutterFire();

    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);

    var collectionReference = firestore.collection('shops');

    String field = 'position';

    Stream<List<DocumentSnapshot>> streamOfNearby = geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: radius, field: field, strictMode: true);

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.green[50],
            onPressed: () {
              setState(() {
                radius = 1;
                _cancleIncrement();
              });
            },
            child: Text(radius.toStringAsFixed(1)),
          ),
          const SizedBox(
            height: 15,
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                radius = radius + 0.1;
              });
            },
            onTap: _increaseRadius,
            onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
              _cancleIncrement();
            },
            onLongPress: () {
              _longPressCancled = false;
              Future.delayed(Duration(milliseconds: 0), () {
                if (!_longPressCancled) {
                  _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
                    _increaseRadius();
                  });
                }
              });
            },
            child: FloatingActionButton(
              backgroundColor: Colors.green[50],
              heroTag: "increment",
              onPressed: () {
                setState(() {
                  radius++;
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          GestureDetector(
            onDoubleTap: () {
              setState(() {
                radius = radius - 0.1;
              });
            },
            onTap: _decreaseRadius,
            onLongPressEnd: (LongPressEndDetails longPressEndDetails) {
              _cancleIncrement();
            },
            onLongPress: () {
              _longPressCancled = false;
              Future.delayed(Duration(milliseconds: 300), () {
                if (!_longPressCancled) {
                  _timer = Timer.periodic(Duration(milliseconds: 150), (timer) {
                    _decreaseRadius();
                  });
                }
              });
            },
            child: FloatingActionButton(
              backgroundColor: Colors.green[50],
              heroTag: "decrement",
              onPressed: () {
                setState(() {
                  radius--;
                });

                print(radius);
              },
              child: const Icon(Icons.remove),
            ),
          ),
        ],
      ),
      appBar: AppBar(
        title: Text(widget.category.title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CreateShop(CollectionREf: widget.category.title)));
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShopMap(
                        collTitle: widget.category.title,
                      ),
                    ));
              },
              icon: const Icon(
                Icons.location_searching,
                fill: 0.0,
              )),
        ],
      ),
      body: Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[





            ]
          ),
        ),
        StreamBuilder<List<DocumentSnapshot>>(
            stream: streamOfNearby,
            builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Lottie.asset('animations/loading.json');
              }

              if (snapshot.hasData) {
                final nearbyDocuments = snapshot.data!;
                final matchingDocuments = nearbyDocuments
                    .where((doc) => doc['category'] == widget.category.title)
                    .toList();

                return ListView.builder(
                  // reverse: true, filter
                    shrinkWrap: true,
                    // itemCount: snapshot.data!.length,
                    itemCount: matchingDocuments.length,
                    itemBuilder: ((context, index) {
                      // DocumentSnapshot data = snapshot.data![index];
                      final data = matchingDocuments[index];

                      GeoPoint documentLocation =
                      data.get('position')['geopoint'];
                      var distanceInMeters = Geolocator.distanceBetween(
                          center.latitude,
                          center.longitude,
                          documentLocation.latitude,
                          documentLocation.longitude);
                      return GestureDetector(
                        onTap: () {
                          print(
                              "<----------------------------------------Checking the problem-------------------------------------->");
                          print(data.get('title'));
                          print(data.id);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShopMessages(
                                      title: widget.category.title,
                                      documentId: data.id)));

                          // MessagesScreen(documentId: data.id,title :data.get('name'))),
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          margin: const EdgeInsets.all(20),
                          color: Colors.orange[50],
                          elevation: 4, // Adjust the elevation value as needed
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${data.get('title')}',
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' public',
                                      style: TextStyle(fontSize: 13),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                        constraints: const BoxConstraints(
                                          minWidth:
                                          40, // Minimum width of the container
                                          maxWidth:
                                          100, // Maximum width of the container
                                        ),
                                        child: Text(
                                          '${data.get('description')}',
                                          style: TextStyle(fontSize: 15),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        constraints: const BoxConstraints(
                                          minWidth:
                                          10, // Minimum width of the container
                                          maxWidth:
                                          200, // Maximum width of the container
                                        ),
                                        child: Text('${data.get('createdAt')}')),
                                    Text(
                                        '${distanceInMeters.convertFromTo(LENGTH.meters, LENGTH.kilometers)!.toStringAsFixed(2)} KM'),
                                    IconButton(onPressed: (){
                                      openGoogleMaps(documentLocation.latitude, documentLocation.longitude);
                                    }, icon: Icon(Icons.directions)),
                                    // IconButton(
                                    //     onPressed: () async {
                                    //
                                    //       var whatsappUrl =
                                    //           "whatsapp://send?phone=${'+91'+'9699684544'}" +
                                    //               "&text=${Uri.encodeComponent("Hello")}";                                  //       try {
                                    //         launch(whatsappUrl);
                                    //       } catch (e) {
                                    //         print(e);
                                    //       }
                                    //
                                    //     },
                                    //     icon: const Icon(Icons.call)),
                                    IconButton(
                                        onPressed: () async {
                                          await launch("tel://+919699684544");

                                        }
                                        ,
                                        icon: const Icon(Icons.call))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }));
              } else {
                return CircularProgressIndicator();
              }

              // return ListView.builder(
              //     shrinkWrap: true,
              //     itemCount: snapshot.data!.length,
              //     itemBuilder: ((context, index) {
              //       DocumentSnapshot data = snapshot.data![index];
              //       GeoPoint documentLocation = data.get('position')['geopoint'];
              //       var distanceInMeters = Geolocator.distanceBetween(
              //           center.latitude,
              //           center.longitude,
              //           documentLocation.latitude,
              //           documentLocation.longitude);
              //       return
              //
              //
              //
              //
              //         GestureDetector(
              //           onTap: (){
              //
              //
              //               print("<----------------------------------------Checking the problem-------------------------------------->");
              //               print(data.get('title'));
              //               print(data.id);
              //
              //               Navigator.push(context, MaterialPageRoute(builder: (context) => MessageScreenDemo(title: data.get('title'),documentId: data.id)));
              //
              //             // MessagesScreen(documentId: data.id,title :data.get('name'))),
              //           },
              //           child: Card(
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(8.0),
              //             ),
              //
              //             margin: const EdgeInsets.all(20),
              //             color: Colors.orange[50],
              //             elevation: 4, // Adjust the elevation value as needed
              //
              //             child: Container(
              //               padding: const EdgeInsets.all(16),
              //               child:  Column(
              //                 crossAxisAlignment:CrossAxisAlignment.start ,
              //                 children: [
              //                   Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Text('${data.get('title')}',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
              //                       SizedBox(height:5,),
              //                       Text(' public',style: TextStyle(fontSize: 13),),
              //                       SizedBox(height: 30,),
              //
              //                       Container(
              //                           constraints: const BoxConstraints(
              //                             minWidth: 40, // Minimum width of the container
              //                             maxWidth: 100, // Maximum width of the container
              //                           ),
              //                           child: Text('${data.get('description')}',style: TextStyle(fontSize: 15),)),
              //                       SizedBox(height: 30,),
              //
              //                     ],
              //                   ),
              //                   Row(
              //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                     children: [
              //                       Container(
              //                           constraints: const BoxConstraints(
              //                             minWidth: 10, // Minimum width of the container
              //                             maxWidth: 200, // Maximum width of the container
              //                           ),
              //                           child: Text('${data.get('createdAt')}')),
              //                       Text(  '${distanceInMeters.convertFromTo(LENGTH.meters, LENGTH.kilometers)!.toStringAsFixed(2)} KM'),
              //                     ],
              //                   )
              //
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //
              //
              //
              //       //   ListTile(
              //       //   onTap: () {
              //       //     Navigator.push(
              //       //       context,
              //       //       MaterialPageRoute(
              //       //           builder: (context) =>
              //       //     MessageScreenDemo())
              //       //               // MessagesScreen(documentId: data.id,title :data.get('name'))),
              //       //     );
              //       //   },
              //       //   title: Text('${data.get('title')}'),
              //       //   subtitle: Column(
              //       //     children: [
              //       //       Text(
              //       //           '${distanceInMeters.convertFromTo(LENGTH.meters, LENGTH.kilometers)!.toStringAsFixed(2)} KM'),
              //       //       // Text('${data.get('description')}')
              //       //
              //       //     ],
              //       //   ),
              //       //
              //       //
              //       // );
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //
              //     }));
            }),
      ],

      ),
    );
  }
}
