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
    );
  }
}
