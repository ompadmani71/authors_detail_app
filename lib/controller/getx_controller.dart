import 'package:get/get.dart';

class HomeController extends GetxController{

  Rx<Error> error = Error().obs;

  RxInt textFieldLength = 1.obs;
  RxBool isShowAdd = false.obs;

}