import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/widgets/drawer.dart';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../widgets/appbar.dart';
import '../widgets/text.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    getData();

    super.initState();
  }

  final box = GetStorage();

  var name = '';
  var contactNumber = '';
  var booking = 0;
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
        booking = data['booking'];
        profilePicture = data['profilePicture'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: appbar('Profile'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              const CircleAvatar(
                minRadius: 50,
                maxRadius: 50,
                backgroundImage: NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              textBold(
                'Lance Olana',
                22,
                Colors.black,
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                  ),
                  title: textReg('+639090104355', 18, Colors.black),
                  subtitle: textReg('Contact Number', 10, Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.bookmark_added_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  title: textReg('0', 18, Colors.black),
                  subtitle: textReg('Booked Rides', 10, Colors.grey),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50),
                child: ListTile(
                  leading: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.payment_rounded,
                      color: Colors.grey,
                    ),
                  ),
                  title: textReg('0', 18, Colors.black),
                  subtitle: textReg('Amount to pay', 10, Colors.grey),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
