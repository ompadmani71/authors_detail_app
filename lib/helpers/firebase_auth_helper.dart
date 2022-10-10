import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FirebaseAuthHelper {
  FirebaseAuthHelper._();

  bool isLoaderShow = false;

  static final FirebaseAuthHelper firebaseAuthHelper = FirebaseAuthHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> emailPasswordSignUP(
      {required String email,
      required String password}) async {
    try {
      UserCredential credential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = credential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      Get.closeAllSnackbars();
      Get.back();

      switch (e.code) {
        case "email-already-in-use":
          Get.snackbar("Failed", "Email Already taken..." ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;

        case "weak-password":
          Get.snackbar("Failed", "Weak Password, try Different..." ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;

        case "network-request-failed":
          Get.snackbar("Failed", "No internet..." ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;

        case "invalid-email":

          Get.snackbar("Failed", "Invalid Email" ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
      }
      print(e);
    }

    return null;
  }

  Future<User?> emailPasswordSignIN(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      UserCredential credential = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = credential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      Get.closeAllSnackbars();
      Get.back();
      switch (e.code) {
        case "wrong-password":
          Get.snackbar("Wrong Password", "Enter right Password",backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white);
          break;

        case "invalid-email":
          Get.snackbar("Failed", "invalid Email..." ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;

        case "network-request-failed":
          Get.snackbar("Failed", "No internet..." ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;

        case "user-disabled":
          Get.snackbar("Failed", "User Disable, try Different Account" ,backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;

        case "user-not-found":
          Get.snackbar("Failed", "User not register yet!",backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
          break;
          
        case "too-many-requests":
          Get.snackbar("Failed", "many Requests",backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white,);
      }
      print(e);
    }

    return null;
  }

  Future<void> signOut()async{
    await firebaseAuth.signOut();
  }
}
