import 'package:flutter/material.dart';
import 'package:get/get.dart';

snack(String title, String msg, SnackPosition pos, IconData icon) {
  return Get.snackbar(
    title,
    msg,
    snackPosition: pos,
    margin: const EdgeInsets.all(0),
    borderRadius: 0,
    icon: Icon(icon),
  );
}
