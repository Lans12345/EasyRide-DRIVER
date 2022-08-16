import 'package:easy_ride_driver/auth/login_page.dart';
import 'package:easy_ride_driver/controllers/signup_controller.dart';
import 'package:easy_ride_driver/services/cloud_function/create_account.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/button.dart';
import 'package:easy_ride_driver/widgets/dialog.dart';
import 'package:easy_ride_driver/widgets/error.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class CarDetails extends StatefulWidget {
  const CarDetails({Key? key}) : super(key: key);

  @override
  State<CarDetails> createState() => _CarDetailsState();
}

class _CarDetailsState extends State<CarDetails> {
  final myController = Get.find<SignupController>();

  var hasLoaded = false;

  var plateNumber = '';
  var carModel = '';
  var carPicture = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarSignUp(),
      body: SingleChildScrollView(
          child: Center(
        child: Column(
          children: [
            hasLoaded
                ? CircleAvatar(
                    backgroundColor: Colors.blue[200],
                    minRadius: 50,
                    maxRadius: 50,
                    // backgroundImage: NetworkImage(imageURL),
                  )
                : GestureDetector(
                    onTap: () {
                      // uploadPicture('gallery');
                    },
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[400],
                      minRadius: 50,
                      maxRadius: 50,
                      child: const Center(
                        child: Icon(
                          Icons.camera_enhance,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            textReg('Upload Picture of Vehicle', 12, Colors.grey),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (_input) {
                  carModel = _input;
                },
                decoration: const InputDecoration(
                  hintText: 'Vehicle Model',
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
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (_input) {
                  plateNumber = _input;
                },
                decoration: const InputDecoration(
                  hintText: 'Plate #',
                  hintStyle: TextStyle(
                    fontFamily: 'QRegular',
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Button(
              buttonText: 'Continue',
              onPressed: () async {
                bool hasInternet =
                    await InternetConnectionChecker().hasConnection;
                if (carModel == '' || plateNumber == '') {
                  error2('Missing Input', 'Cannot Procceed');
                } else {
                  // Store values to firestore

                  if (hasInternet == true) {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: myController.username.value.trim(),
                              password: myController.password.value.trim());

                      createAccount(
                          myController.username.value,
                          myController.password.value,
                          myController.name.value,
                          '+639' + myController.contactNumber.value,
                          myController.profilePicture.value,
                          carPicture,
                          plateNumber,
                          myController.vehicle.value,
                          carModel);
                      dialog('Signup', 'Account Created Succesfully!',
                          const LoginPage());
                    } catch (e) {
                      error(e.toString());
                    }
                  } else {
                    error2('No Internet Connection', 'Cannot Procceed');
                  }
                }
              },
            ),
          ],
        ),
      )),
    );
  }
}
