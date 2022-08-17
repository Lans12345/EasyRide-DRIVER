import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/auth/signup/details_page.dart';
import 'package:easy_ride_driver/services/authentication/sign_in.dart';
import 'package:easy_ride_driver/widgets/button.dart';
import 'package:easy_ride_driver/widgets/error.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import '../widgets/image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    locationNotif();
    super.initState();
  }

  Future<Position> locationNotif() async {
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

  final box = GetStorage();
  var username = '';
  var password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const DetailsPage()));
              },
              child: TextBold(
                  color: Colors.black, fontSize: 18, title: 'Register'),
            ),
          ),
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    image('assets/images/logo.png', 180, 180, EdgeInsets.zero),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextBold(
                            color: Colors.black, fontSize: 48, title: 'Easy'),
                        TextBold(
                            color: Colors.black, fontSize: 54, title: 'Ride'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Divider(
                  height: 0.75,
                  color: Colors.grey[200],
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    onChanged: (_input) {
                      username = _input;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      hintStyle: TextStyle(
                        fontFamily: 'QRegular',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    obscureText: true,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                    onChanged: (_input) {
                      password = _input;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Password',
                      hintStyle: TextStyle(
                        fontFamily: 'QRegular',
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Button(
                    buttonText: 'Login',
                    onPressed: () async {
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      bool serviceEnabled;

                      // Test if location services are enabled.
                      serviceEnabled =
                          await Geolocator.isLocationServiceEnabled();
                      if (!serviceEnabled) {
                        error2("Please turn on your Phone's Location",
                            'Caanot Procceed');
                      } else {
                        bool hasInternet =
                            await InternetConnectionChecker().hasConnection;

                        if (hasInternet == true) {
                          logIn(username, password);
                          FirebaseFirestore.instance
                              .collection('Drivers')
                              .doc(username + '@easyride.cdo.driver')
                              .update({
                            'locationLatitude': position.latitude,
                            'locationLongitude': position.longitude,
                          });
                        } else {
                          error2("No Internet Connection!", 'Caanot Procceed');
                        }
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
