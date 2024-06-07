import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/Constants/validator.dart';
import 'package:kitabylib/SignUp/SignUp2.dart';
import 'package:kitabylib/SignUp/otp_countDown.dart';
import 'package:kitabylib/models/auth/send_otp_request.dart';
import 'package:kitabylib/models/auth/verify_otp_request.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import 'package:kitabylib/Login.dart';

import '../models/api_services.dart';

class SignUp1 extends StatefulWidget {
  const SignUp1({super.key});
  @override
  State<SignUp1> createState() => SignUp1state();
}

class SignUp1state extends State<SignUp1> {
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
      body: Container(
        alignment: Alignment.center,
        decoration:const BoxDecoration(
          image : DecorationImage(image: AssetImage("assets/images/Shape.png"), fit: BoxFit.cover),
        ),
        child: Container(
          height: 665.h,
          width: 456.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24).w,
          color: ColorPalette.SH_Grey100,
          ),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 25 , vertical: 10).w,
              child: ListView(
                //physics:const NeverScrollableScrollPhysics(),
                //physics: const ClampingScrollPhysics(),
                children: [
                  Center(child: Image.asset(Path.Logolib)),
                  WidgetsModels.Container_widget(
                      40.w,
                      33.h,
                      Alignment.center,
                      const EdgeInsets.only(top: 10).w,
                      null,
                      Text("Welcome Here",
                          style: GoogleFonts.montserrat(
                              color: ColorPalette.backgroundcolor,
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w600))),
                  WidgetsModels.Container_widget(
                      20.h,
                      25.w,
                      Alignment.center,
                      const EdgeInsets.only(bottom: 15).w,
                      null,
                      Text("Sign to continue",
                          style: GoogleFonts.montserrat(
                              color: ColorPalette.backgroundcolor,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w300))),
                  WidgetsModels.Container_widget(null , 30.h, Alignment.center, null,
                      null, Image.asset(Path.Selected1)),
                  Form(
                      key: Signup,
                      child: Column(
                        children: [
                          WidgetsModels.customTTF_title(
                              "Full Name",
                              null,
                              _nameController,
                              TextInputType.name,
                              Fieldvalidator.validatename,
                              Icon(
                                FluentIcons.person_24_regular,
                                color: ColorPalette.backgroundcolor,
                              ),
                              null,
                              false,
                              null),
                          WidgetsModels.customTTF_title(
                              "Phone Number",
                              null,
                              _phoneNumberController,
                              TextInputType.number,
                              Fieldvalidator.validatePhoneNumber,
                              Icon(
                                FluentIcons.call_24_regular,
                                color: ColorPalette.backgroundcolor,
                              ),
                              null,
                              false,
                              10),
                          WidgetsModels.customTTF_title(
                              "Code pin",
                              null,
                              _pinController,
                              TextInputType.number,
                              Fieldvalidator.validatePinCode,
                              Icon(
                                FluentIcons.lock_shield_24_regular,
                                color: ColorPalette.backgroundcolor,
                              ),
                              StatefulBuilder(
                            builder: (contextbtn, setStatebtn) =>
                                GestureDetector(
                              onTap: () async {
                                SendOtpRequest phoneOTP =
                                    SendOtpRequest(
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
                                                  if(mounted){
                                              setStatebtn(() {
                                                notsent = true;
                                              });}
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
                                              {data = response.data!,}
                                          });
                                }
                              },
                              child: notsent
                                  ? Text("send",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey900,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w400))
                                  : otpcountDown(
                                      fontWeight: FontWeight.w600,
                                      color: ColorPalette.SH_Grey900,
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
                      VerifyOtpRequest phoneVerifyOTP =
                          VerifyOtpRequest(
                              phone: _phoneNumberController.value.text
                                  .substring(1),
                              otp: _pinController.value.text,
                              data: data);
                      await APISERVICES()
                          .verifyotp(phoneVerifyOTP)
                          .then((response) => {
                                if (response.message == "success")
                                  {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Signup2(
                                          name: _nameController.value.text,
                                          phone: _phoneNumberController.value.text,
                                        ),
                                      )
                                    )
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
                        45.h,
                        Alignment.center,
                        const EdgeInsets.only(bottom: 15 , top: 5 , left: 30 , right: 30).w,
                        BoxDecoration(
                            color: ColorPalette.backgroundcolor,
                            borderRadius: BorderRadius.circular(5).r),
                        Text("Next",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600))))
                  else
                    WidgetsModels.Container_widget(
                        50.w,
                        45.h,
                        Alignment.center,
                        const EdgeInsets.only(bottom: 15 , top: 5 , left: 30 , right: 30).w,
                        BoxDecoration(
                            color: ColorPalette.SH_Grey300,
                            borderRadius: BorderRadius.circular(5).r),
                        Text("Next",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600))),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account ?",
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.backgroundcolor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Login(),
                              ));
                        },
                        child: Text(" Login",
                            style: GoogleFonts.montserrat(
                                color: Colors.lightBlue,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
