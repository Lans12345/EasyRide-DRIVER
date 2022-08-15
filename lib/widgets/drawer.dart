import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/pages/emergency_page.dart';
import 'package:easy_ride_driver/pages/operator_page.dart';
import 'package:easy_ride_driver/pages/profile_page.dart';
import 'package:easy_ride_driver/screens/home_page.dart';
import 'package:easy_ride_driver/widgets/dialog.dart';
import 'package:easy_ride_driver/widgets/text.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'image.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    getData();

    super.initState();
  }

  final box = GetStorage();

  var name = '';
  var contactNumber = '';

  var profilePicture = '';

  getData() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('Users')
        .where('username', isEqualTo: box.read('username'))
        .where('password', isEqualTo: box.read('password'))
        .where('type', isEqualTo: 'user');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        name = data['name'];
        contactNumber = data['contactNumber'];
        profilePicture = data['profilePicture'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Drawer(
        child: ListView(
          padding: const EdgeInsets.only(top: 0),
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(),
              accountEmail: textReg('+639090104355', 12, Colors.black),
              accountName: textBold('Lance Olana', 18, Colors.black),
              currentAccountPicture: const CircleAvatar(
                minRadius: 50,
                maxRadius: 50,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: textBold('Home', 14, Colors.black),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: textBold('Profile', 14, Colors.black),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const ProfilePage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.warning),
              title: textBold('Emergency', 14, Colors.black),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EmergencyPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.engineering),
              title: textBold('Operator', 14, Colors.black),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const OperatorPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: textBold('About', 14, Colors.black),
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationName: 'EasyRide',
                    applicationIcon: image(
                        'assets/images/logo.png', 50, 50, EdgeInsets.zero),
                    applicationLegalese:
                        "Cagayan De Oro's Transport Booking System",
                    applicationVersion: 'v1.0');
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: textBold('Logout', 14, Colors.black),
              onTap: () {
                dialogWithClose(
                  'Confirmation',
                  'Are you sure you want to Logout?',
                  () {},
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
