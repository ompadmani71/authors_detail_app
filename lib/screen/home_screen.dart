import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_miner/helpers/cloud_firestore_helper.dart';
import 'package:firebase_miner/helpers/firebase_auth_helper.dart';
import 'package:firebase_miner/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/getx_controller.dart';
import '../enum/error_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.currentUser}) : super(key: key);

  final User currentUser;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeController incrementController = Get.find();

  GlobalKey<FormState> addAuthorFormKey = GlobalKey<FormState>();

  final blueColor = const Color(0XFF5e92f3);
  final yellowColor = const Color(0XFFfdd835);

  String author_name = "";
  List<String> author_books = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await CloudFirestoreHelper.cloudFireStoreHelper.getAuthorID();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [],
        ),
        body: GetX<HomeController>(builder: (cont) {
          if (cont.error.value == ErrorType.internet) {
            Get.snackbar("ERROR:", "No Internet");
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Stack(
            children: [
              buildBackgroundTopCircle(),
              buildBackgroundBottomCircle(),
              Container(
                height: size.height,
                width: size.width,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 50, bottom: 40),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        "Authors",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Expanded(
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection("Authors").snapshots(),
                        builder: (context, AsyncSnapshot snapShot) {
                          if (snapShot.hasError) {
                            Get.snackbar("ERROR:", "${snapShot.error}",
                                backgroundColor: Colors.red.withOpacity(0.6),
                                colorText: Colors.white);
                            return Center(
                              child: Text("${snapShot.error}"),
                            );
                          } else if (snapShot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Text("Please Wait!"),
                            );
                          } else if (snapShot.hasData) {
                            List<QueryDocumentSnapshot> authorDataList =
                                snapShot.data.docs;

                            print("${authorDataList[2].data()}");

                            return ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              itemCount: authorDataList.length,
                              itemBuilder: (context, index) {
                                Map<String, dynamic> author =
                                    authorDataList[index].data()
                                        as Map<String, dynamic>;

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 7),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 30),
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.7),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 2,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 1),
                                        )
                                      ]),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text("${index + 1}"),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Author: ${author["author_name"]}",
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 30),
                                          const Text(
                                            "Books: ",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  author["bookes"].length,
                                              itemBuilder: (context, i) {
                                                return Text(
                                                  "${author["bookes"][i]}\n",
                                                  maxLines: 1,
                                                );
                                              },
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }
                          return const Center(
                              child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: cont.isShowAdd.value ? 260 : 0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: cont.isShowAdd.value
                          ? Form(
                              key: addAuthorFormKey,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(15,15,15,5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      buildTextField(
                                          labelText: "Author Name: ",
                                          placeholder: "Enter Author Name",
                                          isPassword: false,
                                          onValue: (value) {
                                            author_name = value ?? "";
                                          }),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Books: ",
                                        style: TextStyle(color: blueColor),
                                      ),
                                      const SizedBox(height: 5),
                                      SizedBox(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount:
                                                cont.textFieldLength.value,
                                            padding: EdgeInsets.zero,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        buildIncrementTextField(
                                                      labelText:
                                                          "Book ${index + 1}",
                                                      placeholder:
                                                          "Enter Book ${index + 1} Name here..",
                                                      onSave: (value) {
                                                        author_books.add(value ?? "");
                                                      },
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if(cont.textFieldLength.value != 1){
                                                        cont.textFieldLength
                                                            .value--;
                                                      }
                                                    },
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              left: 10),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        color: Colors
                                                            .grey.shade100,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                      ),
                                                      child: const Icon(
                                                          Icons.remove,
                                                          color: Colors.red,
                                                          size: 15),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            }),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          cont.textFieldLength.value++;
                                        },
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(top: 10),
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: blueColor.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child:
                                              const Icon(Icons.add, size: 15),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                addAuthorFormKey.currentState!.save();

                                                if(author_name.isEmpty){
                                                  Get.snackbar("Failed", "Please Enter Author Name",backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white);
                                                }
                                                if(cont.textFieldLength.value != author_books.length){
                                                  print("object ==> ${cont.textFieldLength.value} / ${author_books.length}");
                                                  Get.snackbar("Failed", "Please Enter All Books Name",backgroundColor: Colors.red.withOpacity(0.6),colorText: Colors.white);
                                                }

                                                if(cont.textFieldLength.value == author_books.length && author_name.isNotEmpty){
                                                  await CloudFirestoreHelper.cloudFireStoreHelper.addAuthor(author_name: author_name, author_books: author_books).then((value) {
                                                    cont.textFieldLength(1);
                                                    author_books.clear();
                                                    cont.isShowAdd(false);
                                                    Get.snackbar("Successes", "Inserted Author Data",backgroundColor: Colors.green.withOpacity(0.6),colorText: Colors.white);
                                                  });
                                                }

                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: blueColor,
                                                foregroundColor: yellowColor,
                                              ),
                                              child: const Text("Save")),
                                          OutlinedButton(
                                              onPressed: () {
                                                setState((){
                                                author_name = "";
                                                author_books.clear();
                                                cont.isShowAdd(false);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  foregroundColor: blueColor
                                              ),
                                              child: const Text("Cancel"))
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(height: 0, width: 0),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: InkWell(
                  onTap: () {
                    cont.isShowAdd.value = !cont.isShowAdd.value;
                  },
                  child: Container(
                    height: 40,
                    width: 110,
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        gradient:
                            LinearGradient(colors: [blueColor, yellowColor]),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.create,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5),
                        Text(
                          "Create",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }));
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
                color: blueColor,
                borderRadius: BorderRadius.circular(
                  MediaQuery.of(context).size.width,
                )),
          ),
        ),
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
            ))
      ],
    );
  }

  Container buildIncrementTextField({
    required String labelText,
    required String placeholder,
    required Function(String?) onSave,
  }) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.zero,
            hintText: placeholder,
            border: InputBorder.none,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          onSaved: onSave,
        ));
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
            color: yellowColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(
              MediaQuery.of(context).size.width,
            )),
      ),
    );
  }
}
