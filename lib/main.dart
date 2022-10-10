import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_miner/controller/getx_controller.dart';
import 'package:firebase_miner/screen/login_screen.dart';
import 'package:firebase_miner/screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  HomeController incrementController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return  const GetMaterialApp(
      home: SplashScreen(),
    );
  }
}
