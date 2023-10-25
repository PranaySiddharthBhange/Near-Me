import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'create_group.dart';
import '../Authentication Services/splash_screen.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}
var mapLatitude=latitude;
var mapLongitude=longitude;

class MapSampleState extends State<MapSample> {



  var faker = Faker();
  String locationName = '';



  final Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(latitude, longitude),
    zoom: 14.4746,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(mapLatitude, mapLongitude),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  final geo = GeoFlutterFire();


  TextEditingController _searchController = TextEditingController();


  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            mini: true,
            onPressed: _goToTheLake,
            child: const Icon(Icons.location_searching),
          ),
        ],
      ),
      body: SafeArea(
        child: Column( 
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _performSearch(_searchController.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                ),
                onSubmitted: (value) {
                  _performSearch(value);
                },
              ),
            ),
            Expanded(
              child: GoogleMap(
                onTap: (coLoc) async {


                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateGroup( latitudeCreate: coLoc.latitude,longitudeCreate: coLoc.longitude,),));






                  // try {
                  //   List<Placemark> placemarks =
                  //       await placemarkFromCoordinates(coLoc.latitude, coLoc.longitude);
                  //   Placemark placemark = placemarks[0];
                  //   String address =
                  //       '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
                  //   print("Pranay Here is resolved name $address");
                  //
                  //   GeoFirePoint myLocation =
                  //       geo.point(latitude: coLoc.latitude, longitude: coLoc.longitude);
                  //   DocumentReference newLocationRef =
                  //       await _firestore.collection('locations').add({
                  //     'name': address,
                  //     'position': myLocation.data,
                  //     'createBy': 'username',
                  //     'createdOn': DateTime.timestamp(),
                  //     'streak': 0,
                  //   });
                  //
                  //   // CollectionReference messagesRef = newLocationRef.collection('messages');
                  //   // // await messagesRef.add({
                  //   // //   'content': 'Hello, World!',
                  //   // //   'latitude': latitude,
                  //   // //   'longitude': longitude,
                  //   // //   'time': DateTime.now().millisecondsSinceEpoch,
                  //   // //   'uid': 'your-user-id',
                  //   // //   'location': locationName
                  //   // // });
                  //   // await messagesRef.add({});
                  // } catch (e) {
                  //   print("Pranay here error.... $e");
                  // }
                },
                mapType: MapType.hybrid,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
  Future<void> _performSearch(String searchQuery) async {
    try {
      final List<Location> locations = await locationFromAddress(searchQuery);
      if (locations.isNotEmpty) {
        final Location location = locations.first;
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(
          LatLng(location.latitude!, location.longitude!),
        ));
      }
    } catch (e) {
      print('Error searching for location: $e');
    }
  }
}

