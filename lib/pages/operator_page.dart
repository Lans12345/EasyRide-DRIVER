import 'package:flutter/material.dart';

import '../widgets/appbar.dart';
import '../widgets/drawer.dart';
import '../widgets/image.dart';
import '../widgets/text.dart';

class OperatorPage extends StatelessWidget {
  const OperatorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: appbar('Operator'),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              image(
                'assets/images/algo.png',
                100,
                220,
                EdgeInsets.zero,
              ),
              const SizedBox(
                height: 10,
              ),
              textBold('Algo Vision', 18, Colors.black),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.location_on_rounded,
                    color: Colors.grey,
                  ),
                ),
                title: textBold('Poblacion, Impasugong, Bukidnon Philippines',
                    14, Colors.black),
                subtitle: textReg('Address', 12, Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.email,
                    color: Colors.grey,
                  ),
                ),
                title: textBold('algovision123@gmail.com', 14, Colors.black),
                subtitle: textReg('Email', 12, Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                ),
                title: textBold('+639090104355', 14, Colors.black),
                subtitle: textReg('Contact Number', 12, Colors.grey),
              ),
              const SizedBox(
                height: 75,
              ),
              textReg(
                'All right reserved',
                12,
                Colors.grey,
              ),
              textReg(
                '2022',
                10,
                Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
