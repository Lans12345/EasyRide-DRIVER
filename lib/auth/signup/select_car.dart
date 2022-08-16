import 'package:easy_ride_driver/auth/signup/car_details.dart';
import 'package:easy_ride_driver/controllers/signup_controller.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SelectCar extends StatefulWidget {
  @override
  State<SelectCar> createState() => _SelectCarState();
}

class _SelectCarState extends State<SelectCar> {
  var images = ['taxi.jpg', 'motor.png', 'rela.jpg', 'jeeppic.png'];

  var vehicle = '';

  final myController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarSignUp(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          textReg('Type of Vehicle', 24, Colors.black),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: SizedBox(
              child: GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () {
                            if (images[index] == images[0]) {
                              setState(() {
                                vehicle = 'Taxi';
                              });
                            } else if (images[index] == images[1]) {
                              setState(() {
                                vehicle = 'Habalhabal';
                              });
                            } else if (images[index] == images[2]) {
                              setState(() {
                                vehicle = 'Rela';
                              });
                            } else if (images[index] == images[3]) {
                              setState(() {
                                vehicle = 'Jeep';
                              });
                            }
                            // Getx Controller
                            myController.getVehicle(vehicle);

                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const CarDetails()));
                          },
                          child: Image(
                            fit: BoxFit.contain,
                            width: 150,
                            height: 150,
                            image: AssetImage('assets/images/' + images[index]),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
