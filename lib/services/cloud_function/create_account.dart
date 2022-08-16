import 'package:cloud_firestore/cloud_firestore.dart';

Future createAccount(
  String username,
  String password,
  String name,
  String contactNumber,
  String profilePicture,
  String carPicture,
  String plateNumber,
  String vehicleType,
  String carModel,
) async {
  final docUser =
      FirebaseFirestore.instance.collection('Drivers').doc(username);

  final json = {
    'username': username,
    'password': password,
    'name': name,
    'contactNumber': contactNumber,
    'profilePicture': profilePicture,
    'carPicture': carPicture,
    'plateNumber': plateNumber,
    'status': 'off',
    'vehicleType': vehicleType,
    'bookedRides': 0,
    'amountToPay': 0,
    'type': 'driver',
    'locationLatitude': 0.00,
    'locationLongitude': 0.00,
    'carModel': carModel,
  };

  await docUser.set(json);
}
