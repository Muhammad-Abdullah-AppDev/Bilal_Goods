import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../screens/menu_screen.dart';
import '../services/service.dart';

class AppController extends GetxController {
  final emailContoller = TextEditingController();
  final passContoller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var loading = false.obs;
  GetStorage _box = GetStorage();
  bool isUserLoggedIn = false;
  String? fkunit;

  @override
  void onInit() {
    super.onInit();
    _box = GetStorage();
    fkunit = _box.read('FKUNIT');
    debugPrint('FKUNIT VAL : $fkunit');
    isUserLoggedIn =
        _box.read('email') != null && _box.read('password') != null;
  }

  Future<void> login() async {
    if (_box.read('FKUNIT') == null) {
      Fluttertoast.showToast(
        msg: 'Please Select A Location',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      loading.value = false;
      update();
    } else if (formKey.currentState!.validate()) {
      loading.value = true;
      update();
      var email = emailContoller.text.trim();
      var password = passContoller.text.trim();
      var data =
          await ApiService.get("Account/Getuser?USID=$email&pwd=$password");
      if (data != null) {
        loading.value = false;
        update();
        var usid = data['USID'];

        debugPrint(data.toString());
        Fluttertoast.showToast(
          msg: 'Login successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        // Store the email and password values in GetStorage
        _box.write('email', email);
        _box.write('password', password);
        _box.write('usid', usid);
        debugPrint(_box.read('email'));
        debugPrint(_box.read('password'));
        debugPrint(_box.read('usid'));
        debugPrint("FKUNIT: ${_box.read('FKUNIT')}");
        emailContoller.clear();
        passContoller.clear();

        Get.offAll(() => MenuScreen());
      } else {
        Fluttertoast.showToast(
          msg: 'Enter Valid Email and Password',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        //debugPrint(data.toString());
        loading.value = false;
        update();
      }
    }
  }

  // Future<void> login() async {
  //   if (formKey.currentState!.validate()) {
  //     loading.value = true;
  //     update();
  //     var email = emailContoller.text.trim();
  //     var password = passContoller.text.trim();
  //     var data =
  //         await ApiService.get("Account/Getuser?USID=$email&pwd=$password");
  //     if (data != null) {
  //       loading.value = false;
  //       update();

  //       print(data.toString());
  //       Fluttertoast.showToast(
  //         msg: 'Login successful',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //       // Store the USID value in GetStorage
  //       GetStorage().write('USID', data['USID']);
  //       Get.offAll(() => MenuScreen());
  //     } else {
  //       Fluttertoast.showToast(
  //         msg: 'Enter Valid Email and Password',
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //       );
  //       print(data.toString());
  //       loading.value = false;
  //       update();
  //     }
  //   }
  // }
}
