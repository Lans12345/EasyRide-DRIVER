import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PalawanPayment extends StatefulWidget {
  const PalawanPayment({Key? key}) : super(key: key);

  @override
  State<PalawanPayment> createState() => _PalawanPaymentState();
}

class _PalawanPaymentState extends State<PalawanPayment> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  final box = GetStorage();

  late int amountToPay;

  getData() async {
    // Use provider
    var collection = FirebaseFirestore.instance
        .collection('Drivers')
        .where('username', isEqualTo: box.read('username'))
        .where('password', isEqualTo: box.read('password'))
        .where('type', isEqualTo: 'driver');

    var querySnapshot = await collection.get();
    setState(() {
      for (var queryDocumentSnapshot in querySnapshot.docs) {
        Map<String, dynamic> data = queryDocumentSnapshot.data();
        amountToPay = data['amountToPay'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarSignUp(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          textBold('Receiver', 28, Colors.black),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: textReg('Lance Olana', 24, Colors.grey),
              subtitle: textReg('Name', 14, Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ListTile(
              leading: const Icon(
                Icons.phone,
                color: Colors.black,
              ),
              title: textReg('09090104355', 24, Colors.grey),
              subtitle: textReg('Mobile Number', 14, Colors.grey),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ListTile(
              leading: const Icon(
                Icons.payment,
                color: Colors.black,
              ),
              title: textReg('${amountToPay}php', 32, Colors.green),
              subtitle: textReg('Amount to pay', 14, Colors.grey),
            ),
          ),
        ],
      ),
    );
  }
}
