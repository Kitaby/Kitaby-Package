// ignore_for_file: file_names, use_build_context_synchronously

import 'dart:async';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/profile/change_profile_request_model.dart';
import 'package:kitaby/profile/ProfileWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Editprofile extends StatefulWidget {
  final String? image;
  final String? wilaya;
  const Editprofile({super.key, required this.image, required this.wilaya});
  @override
  State<Editprofile> createState() => Editprofilestate();
}

class Editprofilestate extends State<Editprofile> {
  String? token;
  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  File? pickedimage;
  final ImagePicker picker = ImagePicker();
  late bool imageAccepted;
  Future takePhoto() async {
    var pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile!.path.endsWith("jpg")) {
      imageAccepted = true;
    } else if (pickedFile.path.endsWith("jpeg")) {
      imageAccepted = true;
    } else {
      imageAccepted = false;
    }
    if (imageAccepted) {
      setState(() {
        pickedimage = File(pickedFile.path);
      });
      await APISERVICES().changepp(pickedimage!).then((response) => {
            if (response.message == "success")
              {
                ScaffoldMessenger.of(context).showSnackBar(
                    WidgetsModels.Dialog_Message("success", "Editprofile",
                        "Your profile picture has been successfully changed")),
              }
            else
              {
                print("flag"),
              }
          });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
          "help",
          "Wrong picture format",
          "You can only pick pg and jpeg formats"));
    }
  }

  List<String> willayas = [
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Alger",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arréridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane",
    "El M'ghair",
    "El Menia",
    "Ouled Djellal",
    "Bordj Baji Mokhtar",
    "Béni Abbès",
    "Timimoun",
    "Touggourt",
    "Djanet",
    "In Salah"
  ];

  DropdownMenuEntry<String> buildmenuitem(String item) => DropdownMenuEntry(
      value: item,
      label: item,
      style: ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(ColorPalette.backgroundcolor)),
      labelWidget: Container(
          color: ColorPalette.backgroundcolor,
          child: Text(
            item,
            style: GoogleFonts.montserrat(
                color: ColorPalette.SH_Grey100,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400),
          )));

  final _willayacontroller = TextEditingController();
  List<String> categories = [
    "mystery",
    "biography",
    "history",
    "drama",
    "fiction",
    "romance",
    "adventure",
    "horror",
    "comedy",
    "science",
    "philosophy",
    "religious"
  ];
  List<String> categoriesselected = [];

  @override
  void initState() {
    getToken();
    super.initState();
    _willayacontroller.text = widget.wilaya!;
  }

  @override
  void dispose() {
    super.dispose();
    _willayacontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Column(
          children: [
            WidgetsModels.title(context),
            SizedBox(
              height: 530.h,
              child: ListView(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 20).w,
                    alignment: Alignment.center,
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width / 3,
                        height: MediaQuery.sizeOf(context).width / 3,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.sizeOf(context).width / 10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: (pickedimage == null)
                                  ? NetworkImage(widget.image!)
                                  : FileImage(pickedimage!) as ImageProvider,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Positioned(
                          bottom: MediaQuery.sizeOf(context).width / 6 * 0.7,
                          right: MediaQuery.sizeOf(context).width / 3 * 1.06,
                          child: GestureDetector(
                            onTap: () {
                              takePhoto();
                            },
                            child: Icon(
                              FluentIcons.camera_add_48_filled,
                              color: ColorPalette.SH_Grey100,
                              size: MediaQuery.sizeOf(context).width / 15,
                            ),
                          ))
                    ],
                  ),
                  Center(
                    child: ProfileWidget.customdropdownmenu(
                      'Change Willaya', 280.w, 280.h, _willayacontroller,
                      willayas.map(buildmenuitem).toList(),

                      //onchanged
                      (value) {
                        if (value != null) {
                          setState(() {
                            _willayacontroller.text = value;
                          });
                        }
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 30, bottom: 10).w,
                    child: Text(
                      'Change Interested Categories',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                      height: 200.h,
                      padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10)
                          .w,
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          return WidgetsModels.customcard1(
                            categories[index],
                            categoriesselected.contains(categories[index]),
                            () {
                              setState(() {
                                if (!categoriesselected
                                    .contains(categories[index])) {
                                  categoriesselected.add(categories[index]);
                                } else {
                                  categoriesselected.remove(categories[index]);
                                }
                              });
                            },
                          );
                        },
                      )),
                ],
              ),
            ),
            GestureDetector(
                onTap: () async {
                  ChangeprofileRequestModel object = ChangeprofileRequestModel(
                      wilaya: _willayacontroller.value.text,
                      categories: categoriesselected);
                  await APISERVICES().changeProfile(object).then((response) => {
                        if (response.message == "success")
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                WidgetsModels.Dialog_Message(
                                    "success",
                                    "Profile changed",
                                    "Your profile has been successfully changed")),
                            Timer(const Duration(seconds: 5), () {
                              context.pop();
                              context.pushReplacementNamed(RoutesName.Home,
                                  pathParameters: {
                                    "token": token!,
                                    "index": "4"
                                  });
                            })
                          }
                        else
                          {
                            ScaffoldMessenger.of(context).showSnackBar(
                                WidgetsModels.Dialog_Message(
                                    "fail", "Unknown", "Unknown Error")),
                          }
                      });
                },
                child: WidgetsModels.Container_widget(
                  null,
                  45.h,
                  Alignment.center,
                  const EdgeInsets.only(left: 80, right: 80, bottom: 30).w,
                  BoxDecoration(
                    color: ColorPalette.SH_Grey100,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  Text(
                    'Save Changes',
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey900,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
