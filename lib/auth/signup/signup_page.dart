import 'package:easy_ride_driver/auth/signup/select_car.dart';
import 'package:easy_ride_driver/controllers/signup_controller.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/button.dart';
import 'package:easy_ride_driver/widgets/error.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  var hasLoaded = false;

  var username = '';
  var password = '';
  var name = '';
  var contactNumber = '';

  final myController = Get.find<SignupController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appbarSignUp(),
      body: SingleChildScrollView(
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
            textReg('Upload Picture', 12, Colors.grey),
            const SizedBox(
              height: 30,
            ),
            textReg('Login Credentials', 14, Colors.black),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (_input) {
                  username = _input;
                },
                decoration: const InputDecoration(
                  hintText: 'Username',
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
                  password = _input;
                },
                decoration: const InputDecoration(
                  hintText: 'Password',
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
            textReg("User's Credentials", 14, Colors.black),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (_input) {
                  name = _input;
                },
                decoration: const InputDecoration(
                  hintText: 'Full Name',
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
                keyboardType: TextInputType.number,
                maxLength: 9,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
                onChanged: (_input) {
                  contactNumber = _input;
                },
                decoration: InputDecoration(
                  prefix: textReg('+639', 16, Colors.black),
                  hintText: 'Contact Number',
                  hintStyle: const TextStyle(
                    fontFamily: 'QRegular',
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Button(
              buttonText: 'Continue',
              onPressed: () {
                if (username == '' ||
                    password == '' ||
                    name == '' ||
                    contactNumber == '') {
                  error2('Missing Input', 'Cannot Procceed');
                } else {
                  if (username.length < 6) {
                    error2('Username too short', 'Invalid');
                  } else if (password.length < 6) {
                    error2('Password too short - minimum of 6 characters',
                        'Invalid');
                  } else if (contactNumber.length < 9) {
                    error2('Invalid Mobile Number', 'Cannot Procceed');
                  } else {
                    myController.getFirst(username + '@easyride.cdo.driver',
                        password, contactNumber, name, /* image picker*/ '');
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => SelectCar()));
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
