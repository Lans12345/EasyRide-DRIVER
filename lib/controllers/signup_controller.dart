import 'package:get/get.dart';

class SignupController extends GetxController {
  var username = ''.obs;
  var password = ''.obs;
  var contactNumber = ''.obs;
  var name = ''.obs;
  var profilePicture = ''.obs;

  var vehicle = ''.obs;

  getFirst(
    var usrnm,
    var psswrd,
    var number,
    var fullname,
    var profilePic,
  ) {
    username.value = usrnm;
    password.value = psswrd;
    contactNumber.value = number;
    name.value = fullname;
    profilePicture.value = profilePic;
  }

  getVehicle(var vehicleType) {
    vehicle.value = vehicleType;
  }
}
