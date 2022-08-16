import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/controllers/userController.dart';
import 'package:easy_ride_driver/screens/map/map_page.dart';
import 'package:easy_ride_driver/widgets/drawer.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    reqPermission();
  }

  final box = GetStorage();

  final myController = Get.find<UserController>();

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: textReg('Are you sure?', 14, Colors.black),
        content: textReg('Do you want to exit?', 14, Colors.black),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: textBold('No', 12, Colors.black),
          ),
          FlatButton(
            onPressed: () => () {
              setState(() {
                status = 'off';
              });
              Navigator.of(context).pop(true);
            },
            child: textBold('Yes', 12, Colors.black),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  var _value = true;
  var status = 'on';

  Future<Position> reqPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        drawer: const MyDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: textBold('Bookings', 18, Colors.black),
          foregroundColor: Colors.black,
          centerTitle: true,
          actions: [
            Container(
              padding: const EdgeInsets.only(right: 20),
              width: 50,
              child: SwitchListTile(
                value: _value,
                onChanged: (value) {
                  setState(() {
                    _value = value;
                    if (_value == true) {
                      status = 'on';
                      FirebaseFirestore.instance
                          .collection('Drivers')
                          .doc(box.read('username'))
                          .update({'status': 'on'});
                    } else {
                      status = 'off';

                      FirebaseFirestore.instance
                          .collection('Drivers')
                          .doc(box.read('username'))
                          .update({'status': 'off'});
                    }
                  });
                },
              ),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Bookings')
                .where('driverUserName', isEqualTo: box.read('username'))
                .where('driverPassword', isEqualTo: box.read('password'))
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                print('error');
                return const Center(child: Text('Something went wrong!'));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                print('waiting');
                return const Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Center(
                      child: CircularProgressIndicator(
                    color: Colors.black,
                  )),
                );
              }
              final data = snapshot.requireData;

              return ListView.builder(
                  itemCount: snapshot.data?.size ?? 0,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Container(
                        height: 180,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                              opacity: 120.0,
                              image: AssetImage("assets/images/map.jpg"),
                              fit: BoxFit.cover),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          maxRadius: 50,
                                          minRadius: 50,
                                          backgroundImage: NetworkImage(data
                                              .docs[index]['profilePicture']),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        textBold(
                                          data.docs[index]['name'],
                                          18,
                                          Colors.white,
                                        ),
                                      ],
                                    ),
                                    const Expanded(
                                      child: SizedBox(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                          onPressed: () async {
                                            bool serviceEnabled;
                                            LocationPermission permission;

                                            // Test if location services are enabled.
                                            serviceEnabled = await Geolocator
                                                .isLocationServiceEnabled();
                                            if (!serviceEnabled) {
                                              // Location services are not enabled don't continue
                                              // accessing the position and request users of the
                                              // App to enable the location services.
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                        title: textBold(
                                                            "Cannot Procceed",
                                                            16,
                                                            Colors.black),
                                                        content: textReg(
                                                            "Please turn on your phone's location",
                                                            14,
                                                            Colors.black),
                                                        actions: <Widget>[
                                                          FlatButton(
                                                            onPressed: () {
                                                              reqPermission();
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true);
                                                            },
                                                            child: textBold(
                                                                "Close",
                                                                15,
                                                                Colors.black),
                                                          ),
                                                        ],
                                                      ));
                                            } else if (serviceEnabled) {
                                              myController.getUserData(
                                                  data.docs[index]
                                                      ['contactNumber'],
                                                  data.docs[index]
                                                      ['destination'],
                                                  data.docs[index]
                                                      ['driverPassword'],
                                                  data.docs[index]
                                                      ['driverUserName'],
                                                  data.docs[index]
                                                      ['locationLatitude'],
                                                  data.docs[index]
                                                      ['locationLongitude'],
                                                  data.docs[index]['name'],
                                                  data.docs[index]['password'],
                                                  data.docs[index]
                                                      ['pickupLocation'],
                                                  data.docs[index]
                                                      ['profilePicture'],
                                                  data.docs[index]['username']);
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const BookingMap()));
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          )),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: IconButton(
                                          onPressed: () async {
                                            if (await canLaunch(
                                                'tel:${data.docs[index]['contactNumber']}')) {
                                              await launch(
                                                  'tel:${data.docs[index]['contactNumber']}');
                                            }
                                          },
                                          icon: const Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                          )),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                textReg(
                                  'To: ' + data.docs[index]['destination'],
                                  14,
                                  Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ),
    );
  }
}
