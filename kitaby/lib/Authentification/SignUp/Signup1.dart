// ignore_for_file: file_names, non_constant_identifier_names, avoid_print, use_build_context_synchronously;
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Authentification/SignUp/otp_countDown.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/validator.dart';
import 'package:kitaby/models/Authentification/Register/phone_otp_request_model.dart';
import 'package:kitaby/models/Authentification/Register/phone_verify_otp_request_model.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import '../../models/api_services.dart';

class Signup1 extends StatefulWidget {
  const Signup1({super.key});
  @override
  State<Signup1> createState() => Signup1state();
}

class Signup1state extends State<Signup1> {
  static String data = "";
  static bool state4 = false;
  static bool state5 = false;
  static bool state6 = false;
  static bool notsent = true;
  static GlobalKey<FormState> Signup = GlobalKey();

  final _nameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _pinController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _nameController.addListener(() {
      final isnameValid = validator.name(_nameController.value.text);
      if (isnameValid != state4) {
        setState(() {
          state4 = isnameValid;
        });
      }
    });

    _phoneNumberController.addListener(() {
      final isPhonenumberValid =
          validator.phone(_phoneNumberController.value.text);
      if (isPhonenumberValid != state5) {
        setState(() {
          state5 = isPhonenumberValid;
        });
      }
    });

    _pinController.addListener(() {
      final isPinValid = Fieldvalidator.isPin(_pinController.value.text);
      if (isPinValid != state6) {
        setState(() {
          state6 = isPinValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneNumberController.dispose();
    _pinController.dispose();
    super.dispose();
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
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25).w,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Center(child: Image.asset(Path.LogoImg)),
              WidgetsModels.Container_widget(
                  50.w,
                  35.h,
                  Alignment.center,
                  const EdgeInsets.only(top: 25).w,
                  null,
                  Text(TextString.welcomehere,
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600))),
              WidgetsModels.Container_widget(
                  20.w,
                  25.h,
                  Alignment.center,
                  const EdgeInsets.only(bottom: 25).w,
                  null,
                  Text(TextString.signupc,
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w300))),
              WidgetsModels.Container_widget(166.w, 35.h, Alignment.center,
                  null, null, Image.asset(Path.Selected1)),
              Form(
                  key: Signup,
                  child: Column(
                    children: [
                      WidgetsModels.customTTF_title(
                          TextString.fullName,
                          const EdgeInsets.only(top: 25).w,
                          _nameController,
                          TextInputType.name,
                          Fieldvalidator.validatename,
                          Icon(
                            FluentIcons.person_24_regular,
                            color: ColorPalette.SH_Grey100,
                          ),
                          null,
                          false,
                          null),
                      WidgetsModels.customTTF_title(
                          TextString.phoneNumber,
                          null,
                          _phoneNumberController,
                          TextInputType.number,
                          Fieldvalidator.validatePhoneNumber,
                          Icon(
                            FluentIcons.call_24_regular,
                            color: ColorPalette.SH_Grey100,
                          ),
                          null,
                          false,
                          10),
                      WidgetsModels.customTTF_title(
                          TextString.codepin,
                          const EdgeInsets.only(bottom: 25).w,
                          _pinController,
                          TextInputType.number,
                          Fieldvalidator.validatePinCode,
                          Icon(
                            FluentIcons.lock_shield_24_regular,
                            color: ColorPalette.SH_Grey100,
                          ),
                          StatefulBuilder(
                            builder: (contextbtn, setStatebtn) =>
                                GestureDetector(
                              onTap: () async {
                                PhoneOtpRequestModel phoneOTP =
                                    PhoneOtpRequestModel(
                                  phone: _phoneNumberController.value.text
                                      .substring(1),
                                );
                                if (notsent) {
                                  await APISERVICES()
                                      .sendotp(phoneOTP)
                                      .then((response) => {
                                            setStatebtn(() {
                                              notsent = false;
                                            }),
                                            Timer(const Duration(minutes: 2),
                                                () {
                                              setStatebtn(() {
                                                notsent = true;
                                              });
                                            }),
                                            if (response.message ==
                                                "you already have an account")
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(WidgetsModels
                                                        .Dialog_Message(
                                                            "info",
                                                            "Used number",
                                                            "Please enter a valid Number ")),
                                              }
                                            else if (response.message !=
                                                "success")
                                              {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(WidgetsModels
                                                        .Dialog_Message(
                                                            "fail",
                                                            "Unkwon error",
                                                            "Please retry later")),
                                              }
                                            else
                                              {data = response.data!}
                                          });
                                }
                              },
                              child: notsent
                                  ? Text(TextString.send,
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400))
                                  : otpcountDown(
                                      fontWeight: FontWeight.w600,
                                      color: ColorPalette.SH_Grey100,
                                      fontSize: 14.sp,
                                      deadline: DateTime.now()
                                          .add(const Duration(minutes: 2))),
                            ),
                          ),
                          false,
                          6),
                    ],
                  )),
              if ((validator.name(_nameController.value.text)) &&
                  (validator.phone(_phoneNumberController.value.text)) &&
                  (Fieldvalidator.isPin(_pinController.value.text)))
                GestureDetector(
                    onTap: () async {
                      PhoneVerifyOtpRequestModel phoneVerifyOTP =
                          PhoneVerifyOtpRequestModel(
                              phone: _phoneNumberController.value.text
                                  .substring(1),
                              otp: _pinController.value.text,
                              data: data);
                      await APISERVICES()
                          .verifyotp(phoneVerifyOTP)
                          .then((response) => {
                                if (response.message == "success")
                                  {
                                    context.pushNamed(RoutesName.Signup2,
                                        pathParameters: {
                                          "name": _nameController.value.text,
                                          "phone": _phoneNumberController
                                              .value.text
                                              .substring(1),
                                        })
                                  }
                                else if (response.message == "expired")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        WidgetsModels.Dialog_Message(
                                            "info",
                                            response.message,
                                            "Your otp is expired send another one")),
                                  }
                                else if (response.message == "fail")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        WidgetsModels.Dialog_Message(
                                            "fail",
                                            "otp incorrect",
                                            "Your code is incorrect please retry")),
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        WidgetsModels.Dialog_Message(
                                            "fail",
                                            "Unkwon error",
                                            "Please retry later")),
                                  }
                              });
                    },
                    child: WidgetsModels.Container_widget(
                        50.w,
                        50.h,
                        Alignment.center,
                        const EdgeInsets.only(bottom: 30).w,
                        BoxDecoration(
                            color: ColorPalette.SH_Grey100,
                            borderRadius: BorderRadius.circular(5).r),
                        Text(TextString.next,
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600))))
              else
                WidgetsModels.Container_widget(
                    50.w,
                    50.h,
                    Alignment.center,
                    const EdgeInsets.only(bottom: 30).w,
                    BoxDecoration(
                        color: ColorPalette.SH_Grey500,
                        borderRadius: BorderRadius.circular(5).r),
                    Text(TextString.next,
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey900,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600))),
              Container(
                margin: const EdgeInsets.only(bottom: 20).w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      TextString.ahaa,
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.pushReplacementNamed(RoutesName.Login);
                      },
                      child: Text(TextString.sLogin,
                          style: GoogleFonts.montserrat(
                              color: Colors.lightBlue,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
