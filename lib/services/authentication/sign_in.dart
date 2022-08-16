import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../../screens/home_page.dart';
import '../../widgets/error.dart';

Future logIn(String email, String password) async {
  final box = GetStorage();
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email + '@easyride.cdo.driver'.trim(),
        password: password.trim());
    FirebaseFirestore.instance
        .collection('Drivers')
        .doc(email + '@easyride.cdo.driver')
        .update({'status': 'on'});
    box.write('username', email + '@easyride.cdo.driver');
    box.write('password', password);
    Get.off(() => const HomePage());
  } catch (e) {
    error(e.toString());
  }
}
