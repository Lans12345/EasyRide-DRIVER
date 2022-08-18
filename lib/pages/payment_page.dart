import 'package:easy_ride_driver/screens/payments/gcash_payment.dart';
import 'package:easy_ride_driver/screens/payments/palawan_payment.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/drawer.dart';
import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      backgroundColor: Colors.white,
      appBar: appbar('Mode of Payment'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GcashPayment()));
              },
              child: Container(
                width: 250.0,
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/gcash.jpg"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const PalawanPayment()));
              },
              child: Container(
                width: 250.0,
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: const DecorationImage(
                      image: AssetImage("assets/images/palawan.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
