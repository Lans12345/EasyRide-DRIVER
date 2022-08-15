import 'package:get/get.dart';

class UserController extends GetxController {
  var contactNumber = ''.obs;
  var destination = ''.obs;
  var driverPassword = ''.obs;
  var driverUserName = ''.obs;
  var locationLatitude = 0.00.obs.toDouble();
  var locationLongitude = 0.00.obs.toDouble();
  var name = ''.obs;
  var password = ''.obs;
  var pickupLocation = ''.obs;
  var profilePicture = ''.obs;
  var username = ''.obs;

  getUserData(
      var num,
      var des,
      var drvrPass,
      var drvrUsername,
      var locLat,
      var locLong,
      var nm,
      var pass,
      var pickupLoc,
      var profilePic,
      var usrName) {
    contactNumber.value = num;
    destination.value = des;
    driverPassword.value = drvrPass;
    driverUserName.value = drvrUsername;
    locationLatitude = locLat;
    locationLongitude = locLong;
    name.value = nm;
    password.value = pass;
    pickupLocation.value = pickupLoc;
    profilePicture.value = profilePic;
    username.value = usrName;
  }
}
