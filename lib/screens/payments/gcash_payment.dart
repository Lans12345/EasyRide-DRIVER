import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/button.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';

class GcashPayment extends StatefulWidget {
  const GcashPayment({Key? key}) : super(key: key);

  @override
  State<GcashPayment> createState() => _GcashPaymentState();
}

class _GcashPaymentState extends State<GcashPayment> {
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textBold('Pay using QR Code', 15, Colors.black),
              const SizedBox(height: 20),
              Container(
                width: 250.0,
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/qrcode_sample.jpg"),
                      fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(height: 20),
              textBold('or', 12, Colors.grey),
              const SizedBox(height: 20),
              textBold('Send payment through: ', 15, Colors.black),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      ),
                      color: Colors.blueGrey.withOpacity(0.10),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: textReg('09090104355', 18, Colors.grey[700]!),
                      ),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      ),
                      color: Colors.grey[300],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Clipboard.setData(
                          const ClipboardData(text: '09090104355'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('GCash Number Copied Succesfully!'),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.copy,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              textBold(amountToPay.toString() + 'php', 32, Colors.green),
              textReg('Amount to pay', 15, Colors.grey),
              const SizedBox(height: 30),
              Button(
                  buttonText: 'Open GCash App',
                  onPressed: () async {
                    // Launch GCASH App
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
