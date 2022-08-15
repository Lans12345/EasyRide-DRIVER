import 'package:easy_ride_driver/utils/hotlines/hospital_hotlines.dart';
import 'package:easy_ride_driver/utils/hotlines/police_hotlines.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/drawer.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyPage extends StatelessWidget {
  const EmergencyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      appBar: appbar('Hotlines'),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            textBold('Police Hotlines', 24, Colors.black),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: policeHotlines.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: textBold(policeStation[index], 18, Colors.black),
                      leading: const Icon(
                        Icons.star_purple500_outlined,
                        color: Colors.blue,
                      ),
                      subtitle:
                          textReg(policeStationPlaces[index], 14, Colors.grey),
                      trailing: IconButton(
                        onPressed: () async {
                          if (await canLaunch('tel:${policeHotlines[index]}')) {
                            await launch('tel:${policeHotlines[index]}');
                          }
                        },
                        icon: const Icon(Icons.call),
                        color: Colors.green,
                      ),
                    );
                  }),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            textBold('Hospital Hotlines', 24, Colors.black),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                child: ListView.builder(
                  itemCount: hospitalHotlines.length,
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: textBold(hospital[index], 18, Colors.black),
                      leading: const Icon(
                        Icons.local_hospital_rounded,
                        color: Colors.red,
                      ),
                      subtitle: textReg(hospitalPlces[index], 14, Colors.grey),
                      trailing: IconButton(
                        onPressed: () async {
                          if (await canLaunch(
                              'tel:${hospitalHotlines[index]}')) {
                            await launch('tel:${hospitalHotlines[index]}');
                          }
                        },
                        icon: const Icon(Icons.call),
                        color: Colors.green,
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
