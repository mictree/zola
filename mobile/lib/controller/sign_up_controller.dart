import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zola/models/signup_info_model.dart';

class SignUpController extends GetxController {
  var currentStep = 1.obs;
  var signUpInfo = SignUpInfo().obs;

  void updateEmail(String email) {
    debugPrint("Updating email: $email");
    signUpInfo.update((val) {
      val!.email = email;
    });
  }

  void updateOtp(String otp) {
    signUpInfo.update((val) {
      val!.otp = otp;
    });
  }

  void updateName(String name) {
    debugPrint("Updating name: $name");
    signUpInfo.update((val) {
      val!.fullname = name;
    });
  }

  void updatePassword(String password) {
    debugPrint("Updating password: $password");
    signUpInfo.update((val) {
      val!.password = password;
    });
  }

  void updateDob(String dob) {
    debugPrint("Updating birthday: $dob");
    signUpInfo.update((val) {
      val!.birthday = dob;
    });
  }

  void nextStep() {
    currentStep.value++;
  }

  void prevStep() {
    currentStep.value--;
  }

  void clear() {
    //clear all data
    signUpInfo.value = SignUpInfo();
    currentStep.value = 1;
  }
}
