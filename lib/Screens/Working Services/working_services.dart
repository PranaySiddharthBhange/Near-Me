import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geofire/Screens/Working%20Services/create_service.dart';
import 'package:geofire/Screens/Working%20Services/worker_info.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';


import '../Authentication Services/splash_screen.dart';

class WorkingServices extends StatefulWidget {
  final category;

  const WorkingServices({Key? key, required this.category}) : super(key: key);

  @override
  State<WorkingServices> createState() => _WorkingServicesState();
}

class _WorkingServicesState extends State<WorkingServices> {
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

  @override
  Widget build(BuildContext context) {
    final firestore = FirebaseFirestore.instance;

    final geo = GeoFlutterFire();

    GeoFirePoint center = geo.point(latitude: latitude, longitude: longitude);

    var collectionReference = firestore.collection('workers');

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
                        builder: (context) => CreateService(
                            CollectionREf: widget.category.title)));
              },
              icon: const Icon(
                Icons.add,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                // Navigator.push(context, MaterialPageRoute(builder: (context) => ShopMap(collTitle: widget.category.title,),));
              },
              icon: const Icon(
                Icons.location_searching,
                fill: 0.0,
              )),
        ],
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
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

                          Navigator.push(context, MaterialPageRoute(builder: (context) => WorkerInformation(title: data.get('title'),documentId: data.id)));

                        },
                        child:
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.all(15),
                          height: 130,
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
                          child: Center(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    data['image'],
                                    width: 100,
                                    height: 120,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 200),
                                      child:  Text(
                                        '${data.get('title')}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 25),
                                      ),
                                    ),
                                    Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 200),
                                        child:  Text(
                                          '${data.get('bio')}',
                                          style: TextStyle(fontSize: 15),
                                        )),
                                     Padding(
                                      padding: EdgeInsets.only(top: 14),
                                      child: Row(
                                        children: [Text('Experience: ${data.get('exp')}')],
                                      ),
                                    )
                                  ],
                                )

                              ],
                            ),
                          ),
                        )

                        // Card(
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(8.0),
                        //   ),
                        //
                        //   margin: const EdgeInsets.all(20),
                        //   color: Colors.orange[50],
                        //   elevation: 4, // Adjust the elevation value as needed
                        //
                        //   child: Container(
                        //     padding: const EdgeInsets.all(16),
                        //     child:  Column(
                        //       crossAxisAlignment:CrossAxisAlignment.start ,
                        //       children: [
                        //         Row(
                        //           children: [
                        //             CircleAvatar(
                        //               radius: 80,
                        //               backgroundImage: NetworkImage(data['profile'] ),
                        //             ),
                        //             Column(
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Text('${data.get('title')}',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500),),
                        //                 SizedBox(height:5,),
                        //                 Text(' public',style: TextStyle(fontSize: 13),),
                        //                 SizedBox(height: 30,),
                        //
                        //                 Container(
                        //                     constraints: const BoxConstraints(
                        //                       minWidth: 40, // Minimum width of the container
                        //                       maxWidth: 100, // Maximum width of the container
                        //                     ),
                        //                     child: Text('${data.get('description')}',style: TextStyle(fontSize: 15),)),
                        //                 SizedBox(height: 30,),
                        //
                        //               ],
                        //             ),
                        //           ],
                        //         ),
                        //         Row(
                        //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //           children: [
                        //             Container(
                        //                 constraints: const BoxConstraints(
                        //                   minWidth: 10, // Minimum width of the container
                        //                   maxWidth: 200, // Maximum width of the container
                        //                 ),
                        //                 child: Text('${data.get('createdAt')}')),
                        //             Text(  '${distanceInMeters.convertFromTo(LENGTH.meters, LENGTH.kilometers)!.toStringAsFixed(2)} KM'),
                        //
                        //           ],
                        //         )
                        //
                        //       ],
                        //     ),
                        //   ),
                        // ),
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
    );
  }
}
