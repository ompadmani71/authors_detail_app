import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/helpers/firebase_auth_helper.dart';
import 'package:firebase_miner/screen/home_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> signINKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUPKey = GlobalKey<FormState>();

  final blueColor = const Color(0XFF5e92f3);
  final yellowColor = const Color(0XFFfdd835);

  TapGestureRecognizer? tapGestureRecognizer;
  bool showSignIn = true;

  String signInEmail = "";
  String signInPassword = "";

  String signUpUsername = "";
  String signUpEmail = "";
  String signUpMobile = "";
  String signUpPassword = "";

  @override
  void initState() {
    super.initState();
    tapGestureRecognizer = TapGestureRecognizer()
      ..onTap = () {
        setState(() {
          showSignIn = !showSignIn;
        });
      };
  }

  @override
  void dispose() {
    super.dispose();
    tapGestureRecognizer!.dispose();

    signInEmail = "";
    signInPassword = "";

    signUpEmail = "";
    signUpMobile = "";
    signUpPassword = "";
    signUpUsername = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        buildBackgroundTopCircle(),
        buildBackgroundBottomCircle(),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 50, bottom: 40),
              child: Column(
                children: [
                  Text(
                    showSignIn ? "SIGN IN" : "CREATE ACCOUNT",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  buildAvatarContainer(),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOutBack,
                    height: showSignIn ? 240 : 400,
                    margin: EdgeInsets.only(top: showSignIn ? 40 : 30),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 2,
                            spreadRadius: 1,
                            offset: const Offset(0, 1),
                          )
                        ]),
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        showSignIn
                            ? buildSignInTextFieldSection()
                            : buildSignUpTextFieldSection(),
                      ],
                    )
                        // child: showSignIn
                        //     ? buildSignInTextFieldSection()
                        //     : buildSignUpTextFieldSection(),
                        ),
                  ),
                  showSignIn
                      ? buildSingInBottomSection()
                      : buildSingUpBottomSection(),
                ],
              ),
            ),
          ),
        ),
        // if(FirebaseAuthHelper.firebaseAuthHelper.isLoaderShow)
        //   WillPopScope(child: CircularProgressIndicator(color: yellowColor), onWillPop: ()=> Future.value(false))
      ],
    ));
  }

  Container buildSingInBottomSection() {
    return Container(
      margin: const EdgeInsets.only(top: 50),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              print("Forget Password");
            },
            child: Text(
              "Forget Password ?",
              style: TextStyle(
                color: blueColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: blueColor,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 12),
            ),
            onPressed: () async {
              signINKey.currentState!.save();
              if (signInEmail.isEmpty) {
                Get.snackbar("Failed", "First Enter Email Address...",
                    backgroundColor: Colors.red.withOpacity(0.6),
                    colorText: Colors.white);
              }
              if (signInEmail.isNotEmpty && signInPassword.isEmpty) {
                Get.snackbar("Failed", "First Enter Password...",
                    backgroundColor: Colors.red.withOpacity(0.6),
                    colorText: Colors.white);
              }
              if (signInEmail.isNotEmpty && signInPassword.isNotEmpty) {

                Get.dialog(
                  WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: const Center(child: CircularProgressIndicator())),
                  barrierDismissible: false,
                );
                User? currentUser = await FirebaseAuthHelper.firebaseAuthHelper
                    .emailPasswordSignIN(
                        email: signInEmail,
                        password: signInPassword,
                        context: context);
                // Get.back(closeOverlays: true);
                if (currentUser != null) {
                  Get.snackbar("Login Successfully", "${currentUser.email}",
                      backgroundColor: Colors.green.withOpacity(0.8),
                      colorText: Colors.white);
                  Get.offAll(HomeScreen(currentUser: currentUser));
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_right,
                  color: yellowColor,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          RichText(
            text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: "Create an Account",
                      recognizer: tapGestureRecognizer,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: blueColor,
                        fontWeight: FontWeight.bold,
                      ))
                ]),
          )
        ],
      ),
    );
  }

  Container buildSingUpBottomSection() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: yellowColor,
              elevation: 10,
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
            ),
            onPressed: () async {
              signUPKey.currentState!.save();

              if (signUpUsername.isEmpty) {
                Get.snackbar("Failed", "First Enter UserName...",
                    backgroundColor: Colors.red.withOpacity(0.6),
                    colorText: Colors.white);
              }
              if (signUpUsername.isNotEmpty && signUpEmail.isEmpty) {
                Get.snackbar("Failed", "First Enter Email Address...",
                    backgroundColor: Colors.red.withOpacity(0.6),
                    colorText: Colors.white);
              }
              if (signUpUsername.isNotEmpty &&
                  signUpEmail.isNotEmpty &&
                  signUpMobile.isEmpty) {
                Get.snackbar("Failed", "First Enter Mobile No...",
                    backgroundColor: Colors.red.withOpacity(0.6),
                    colorText: Colors.white);
              }
              if (signUpUsername.isNotEmpty &&
                  signUpEmail.isNotEmpty &&
                  signUpMobile.isNotEmpty &&
                  signUpPassword.isEmpty) {
                Get.snackbar("Failed", "First Enter Password...",
                    backgroundColor: Colors.red.withOpacity(0.6),
                    colorText: Colors.white);
              }

              if (signUpUsername.isNotEmpty &&
                  signUpEmail.isNotEmpty &&
                  signUpMobile.isNotEmpty &&
                  signUpPassword.isNotEmpty) {

                Get.dialog(
                  WillPopScope(
                      onWillPop: () => Future.value(false),
                      child: const Center(child: CircularProgressIndicator())),
                  barrierDismissible: false,
                );

                User? currentUser = await FirebaseAuthHelper.firebaseAuthHelper
                    .emailPasswordSignUP(
                        email: signUpEmail,
                        password: signUpPassword);

                if (currentUser != null) {
                  Get.snackbar(
                      "Create account Successfully", "${currentUser.email}",
                      backgroundColor: Colors.green.withOpacity(0.8),
                      colorText: Colors.white);
                  Get.offAll(HomeScreen(currentUser: currentUser));
                }
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text(
                  "SUBMIT",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Icon(
                  Icons.arrow_right,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 18,
          ),
          RichText(
            text: TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                      text: "Sing in",
                      recognizer: tapGestureRecognizer,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: blueColor,
                        fontWeight: FontWeight.bold,
                      ))
                ]),
          )
        ],
      ),
    );
  }

  Form buildSignInTextFieldSection() {
    return Form(
      key: signINKey,
      child: Column(
        children: [
          buildTextField(
              labelText: "EMAIL ADDRESS",
              placeholder: "Email",
              isPassword: false,
              onValue: (value) {
                setState(() {
                  signInEmail = value ?? "";
                });
              },
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 30,
          ),
          buildTextField(
            onValue: (value) {
              setState(() {
                signInPassword = value ?? '';
              });
            },
            labelText: "PASSWORD",
            placeholder: "Password",
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Form buildSignUpTextFieldSection() {
    return Form(
      key: signUPKey,
      child: Column(
        children: [
          buildTextField(
            onValue: (value) {
              signUpUsername = value ?? '';
            },
            labelText: "USERNAME",
            placeholder: "Username",
            isPassword: false,
          ),
          const SizedBox(
            height: 20,
          ),
          buildTextField(
              onValue: (value) {
                signUpEmail = value ?? '';
              },
              labelText: "EMAIL ADDRESS",
              placeholder: "Email",
              isPassword: false,
              textInputType: TextInputType.emailAddress),
          const SizedBox(
            height: 20,
          ),
          buildTextField(
              onValue: (value) {
                signUpMobile = value ?? '';
              },
              labelText: "MOBILE NUMBER",
              placeholder: "Mobile No.",
              isPassword: false,
              textInputType: TextInputType.phone),
          const SizedBox(
            height: 20,
          ),
          buildTextField(
            onValue: (value) {
              signUpPassword = value ?? '';
            },
            labelText: "PASSWORD",
            placeholder: "Password",
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Column buildTextField(
      {required String labelText,
      required String placeholder,
      required bool isPassword,
      required Function(String?) onValue,
      TextInputType? textInputType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: TextStyle(color: blueColor, fontSize: 12),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8)),
            child: TextFormField(
              obscureText: isPassword,
              keyboardType: (textInputType == null) ? null : textInputType,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                hintText: placeholder,
                border: InputBorder.none,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onSaved: onValue,
            )
            )
      ],
    );
  }

  Container buildAvatarContainer() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      width: 130,
      height: 130,
      decoration: BoxDecoration(
          color: showSignIn ? yellowColor : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(65),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 20,
            ),
          ]),
      child: Center(
        child: Stack(
          children: [
            Positioned(
              left: 1.0,
              top: 3.0,
              child: Icon(
                Icons.person_outline,
                size: 60,
                color: Colors.black.withOpacity(.1),
              ),
            ),
            const Icon(
              Icons.person_outline,
              size: 60,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildBackgroundBottomCircle() {
    return Positioned(
      top: MediaQuery.of(context).size.height -
          MediaQuery.of(context).size.width,
      right: MediaQuery.of(context).size.width / 2,
      child: Container(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: blueColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            )),
      ),
    );
  }

  SnackBar snackBar({required String title}) {
    return SnackBar(
      content: Text(title),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
          label: "Remove",
          onPressed: () {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
          }),
    );
  }

  Positioned buildBackgroundTopCircle() {
    return Positioned(
      top: 0,
      child: Transform.translate(
        offset: Offset(0.0, -MediaQuery.of(context).size.width / 1.3),
        child: Transform.scale(
          scale: 1.35,
          child: Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: showSignIn ? Colors.grey.shade800 : blueColor,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width,
                )),
          ),
        ),
      ),
    );
  }
}
