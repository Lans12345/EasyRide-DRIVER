import 'package:easy_ride_driver/auth/login_page.dart';
import 'package:easy_ride_driver/controllers/signup_controller.dart';
import 'package:easy_ride_driver/services/cloud_function/create_account.dart';
import 'package:easy_ride_driver/widgets/appbar.dart';
import 'package:easy_ride_driver/widgets/button.dart';
import 'package:easy_ride_driver/widgets/dialog.dart';
import 'package:easy_ride_driver/widgets/error.dart';
import 'package:easy_ride_driver/widgets/text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'dart:io';

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

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  late String fileName = '';
  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;
    try {
      pickedImage = (await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920))!;

      fileName = path.basename(pickedImage.path);
      imageFile = File(pickedImage.path);

      try {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => const Padding(
            padding: EdgeInsets.only(left: 30, right: 30),
            child: AlertDialog(
                title: Text(
              '         Loading . . .',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w200,
                  fontFamily: 'Quicksand'),
            )),
          ),
        );

        await firebase_storage.FirebaseStorage.instance
            .ref('Cars/$fileName')
            .putFile(imageFile);
        imageURL = await firebase_storage.FirebaseStorage.instance
            .ref('Cars/$fileName')
            .getDownloadURL();

        setState(() {
          hasLoaded = true;
        });

        Navigator.of(context).pop();
      } on firebase_storage.FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

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
                    backgroundImage: NetworkImage(imageURL),
                  )
                : GestureDetector(
                    onTap: () {
                      uploadPicture('gallery');
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
                          imageURL,
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
