import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/controllers/userController.dart';
import 'package:easy_ride_driver/screens/home_page.dart';
import 'package:easy_ride_driver/services/error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/api.dart';
import '../../widgets/text.dart';

class BookingMap extends StatefulWidget {
  const BookingMap({Key? key}) : super(key: key);

  @override
  _BookingMapState createState() => _BookingMapState();
}

class _BookingMapState extends State<BookingMap> {
  PolylinePoints polyPoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline(double driverLat, double driverLong, double userLat,
      double userLong) async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polyPoints.getRouteBetweenCoordinates(
      "AIzaSyDdXaMN5htLGHo8BkCfefPpuTauwHGXItU",
      PointLatLng(driverLat, driverLong),
      PointLatLng(userLat, userLong),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }
    } else {}
    _addPolyLine(polylineCoordinates);
  }

  LatLng sourceLocation = const LatLng(28.432864, 77.002563);
  LatLng destinationLatlng = const LatLng(28.431626, 77.002475);

  final Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _marker = <Marker>{};

  final Set<Polyline> _polylines = <Polyline>{};
  List<LatLng> polylineCoordinates = [];

  late PolylinePoints polylinePoints2;
  late PolylinePoints polylinePoints1;

  late StreamSubscription<LocationData> subscription;

  LocationData? currentLocation;
  late LocationData destinationLocation;
  late Location location;

  @override
  void initState() {
    super.initState();

    location = Location();
    polylinePoints2 = PolylinePoints();

    subscription = location.onLocationChanged.listen((clocation) {
      currentLocation = clocation;

      updatePinsOnMap();
    });

    setInitialLocation();
  }

  void setInitialLocation() async {
    await location.getLocation().then((value) {
      currentLocation = value;
      setState(() {});
    });

    destinationLocation = LocationData.fromMap({
      "latitude": destinationLatlng.latitude,
      "longitude": destinationLatlng.longitude,
    });
  }

  void showLocationPins() async {
    // Driver Current Location
    var sourceposition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);
    _marker.add(Marker(
      markerId: const MarkerId('sourcePosition'),
      position: sourceposition,
    ));

    // Pick Up Location Marker
    var pickUpPosition =
        LatLng(myController.locationLatitude, myController.locationLongitude);
    _marker.add(
      Marker(
        infoWindow: const InfoWindow(
          title: 'Location of Passenger',
        ),
        markerId: const MarkerId('pickUpLocationOfPassenger'),
        position: pickUpPosition,
        icon: await BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(
            size: Size(24, 24),
          ),
          'assets/images/user.png',
        ),
      ),
    );

    setPolylinesInMap();
  }

  late Polyline _poly;

  void setPolylinesInMap() async {
    // Pick Up Location Polyline
    var result = await polylinePoints2.getRouteBetweenCoordinates(
      GoogleMapApi().url,
      // Current Location of Driver
      PointLatLng(
          currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0),
      // Pick Up Location of Passenger
      const PointLatLng(8.311283, 125.004636),
    );

    if (result.points.isNotEmpty) {
      for (var pointLatLng in result.points) {
        polylineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setState(() {
      _polylines.add(Polyline(
        width: 5,
        polylineId: const PolylineId('polyline1'),
        color: Colors.red,
        points: polylineCoordinates,
      ));
    });
  }

  addMarker() {
    var sourcePosition = LatLng(
        currentLocation!.latitude ?? 0.0, currentLocation!.longitude ?? 0.0);
    _marker.add(Marker(
      markerId: const MarkerId('sourcePosition'),
      icon: BitmapDescriptor.defaultMarker,
      position: sourcePosition,
    ));
  }

  void updatePinsOnMap() async {
    CameraPosition cameraPosition = CameraPosition(
      zoom: 18,
      target: LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
    );

    /* _getPolyline(currentLocation!.latitude!, currentLocation!.longitude!,
        8.311283, 125.004636);
        */

    _poly = Polyline(
        color: Colors.red,
        polylineId: const PolylineId('lans'),
        points: [
          // User Location
          LatLng(myController.locationLatitude, myController.locationLongitude),
          LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
        ],
        width: 4);

    _placeDistance = Geolocator.distanceBetween(
        myController.locationLatitude,
        myController.locationLongitude,
        currentLocation!.latitude!,
        currentLocation!.longitude!);

/* 
    _polylines.add(Polyline(
      width: 5,
      polylineId: const PolylineId('lans1'),
      color: Colors.red,
      points: [
        // User Location
        const LatLng(8.311283, 125.004636),
        LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
      ],
    ));
    */

    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    setState(() {
      _marker.removeWhere((marker) => marker.mapsId.value == 'sourcePosition');
      addMarker();
    });
  }

  final myController = Get.find<UserController>();

  late double _placeDistance = 0;

  @override
  Widget build(BuildContext context) {
    CameraPosition initialCameraPosition = CameraPosition(
      zoom: 16,
      target: currentLocation != null
          ? LatLng(currentLocation!.latitude ?? 0.0,
              currentLocation!.longitude ?? 0.0)
          : const LatLng(0.0, 0.0),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: textBold('On Ride', 18, Colors.white),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                        opacity: 150.0,
                        image: AssetImage("assets/images/map.jpg"),
                        fit: BoxFit.cover),
                  ),
                  height: 200,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(myController.profilePicture.value),
                            maxRadius: 60,
                            minRadius: 60,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () async {
                              if (await canLaunch(
                                  'tel:${myController.contactNumber.value}')) {
                                await launch(
                                    'tel:${myController.contactNumber.value}');
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: textReg('Call', 12, Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          textBold(myController.name.value, 24, Colors.white),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: Text(
                              'From: ' + myController.pickupLocation.value,
                              style: const TextStyle(
                                  fontFamily: 'QRegular',
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: Text(
                              'To: ' + myController.destination.value,
                              style: const TextStyle(
                                  fontFamily: 'QRegular',
                                  fontSize: 12,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Column(
                        children: [
                          textReg('Total Distance', 10, Colors.white),
                          const SizedBox(
                            height: 5,
                          ),
                          textBold(
                              (_placeDistance * 0.001).toStringAsFixed(2) +
                                  ' km',
                              18,
                              Colors.white),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: GoogleMap(
                      zoomControlsEnabled: true,
                      myLocationButtonEnabled: false,
                      compassEnabled: false,
                      markers: _marker,
                      polylines: {_poly},
                      mapType: MapType.normal,
                      initialCameraPosition: initialCameraPosition,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        /*_getPolyline(
                                  currentLocation!.latitude!,
                                  currentLocation!.longitude!,
                                  8.311283,
                                  125.004636);
                                  */

                        showLocationPins();
                      },
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      color: Colors.black,
                      onPressed: () {
                        print(currentLocation!.latitude);
                        print(currentLocation!.longitude);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: textReg('Are you sure?', 14, Colors.black),
                            content: textReg(
                                'You want to end the ride?', 14, Colors.black),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: textBold('No', 18, Colors.black),
                              ),
                              FlatButton(
                                onPressed: () {
                                  try {
                                    FirebaseFirestore.instance
                                        .collection('Bookings')
                                        .doc(myController.driverUserName.value +
                                            '-' +
                                            myController.driverPassword.value)
                                        .delete();
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage()));
                                  } catch (e) {
                                    error(e.toString());
                                  }
                                },
                                child: textBold('Yes', 18, Colors.black),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: textReg('End Ride', 15, Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();

    super.dispose();
  }
}
