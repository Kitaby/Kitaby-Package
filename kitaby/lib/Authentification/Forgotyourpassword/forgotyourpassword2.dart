// ignore_for_file: non_constant_identifier_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/validator.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Path.dart';
import 'package:regexed_validator/regexed_validator.dart';

import '../../models/api_services.dart';
import '../../models/Authentification/ForgotPassword/resset_password_request_model.dart';

class Forgotyourpassword2 extends StatefulWidget {
  final String? email;
  const Forgotyourpassword2({
    super.key,
    required this.email,
  });
  @override
  State<Forgotyourpassword2> createState() => Forgotyourpassword2state();
}

class Forgotyourpassword2state extends State<Forgotyourpassword2> {
  static String email = '';
  final _newpasswordController = TextEditingController();
  final _confirmnewpasswordController = TextEditingController();
  final _pinController = TextEditingController();
  static GlobalKey<FormState> forgotyourpassword2 = GlobalKey();
  static bool state = false;
  static bool state2 = false;
  static bool state3 = false;
  static bool hidetext = true;
  static bool hidetext2 = true;
  static bool isStreched = true;
  @override
  void initState() {
    super.initState();
    if (widget.email == ' ') {
      email = '';
    } else {
      email = widget.email!;
    }
    _newpasswordController.addListener(() {
      final isnewpasswordValid =
          validator.password(_newpasswordController.value.text);
      if (isnewpasswordValid != state) {
        setState(() {
          state = isnewpasswordValid;
        });
      }
    });

    _confirmnewpasswordController.addListener(() {
      final isnewpasswordValid =
          validator.password(_confirmnewpasswordController.value.text);
      if (isnewpasswordValid != state2) {
        setState(() {
          state2 = isnewpasswordValid;
        });
      }
    });

    _pinController.addListener(() {
      final isPinValid = Fieldvalidator.isPin(_pinController.value.text);
      if (isPinValid != state3) {
        setState(() {
          state3 = isPinValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _newpasswordController.dispose();
    _confirmnewpasswordController.dispose();
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
        child: ListView(physics: const ClampingScrollPhysics(), children: [
          WidgetsModels.Container_widget(
              null,
              null,
              Alignment.center,
              const EdgeInsets.only(bottom: 35).w,
              null,
              Image.asset(Path.LogoImg)),
          WidgetsModels.Container_widget(
              null,
              40.h,
              Alignment.center,
              const EdgeInsets.only(bottom: 10).w,
              null,
              Text(
                TextString.forgotpassword,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700),
              )),
          WidgetsModels.Container_widget(
              null,
              25.h,
              Alignment.center,
              const EdgeInsets.only(bottom: 15).w,
              null,
              Text(
                TextString.changepassword,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500),
              )),
          Form(
              key: forgotyourpassword2,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 35).w,
                    padding: const EdgeInsets.symmetric(horizontal: 25).w,
                    child: WidgetsModels.customTTF_title(
                        TextString.newpassword,
                        null,
                        _newpasswordController,
                        TextInputType.visiblePassword,
                        Fieldvalidator.validatepassword,
                        Icon(
                          FluentIcons.key_20_regular,
                          color: ColorPalette.SH_Grey100,
                          size: 20.sp,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              hidetext = !hidetext;
                            });
                          },
                          child: hidetext
                              ? Icon(
                                  FluentIcons.eye_off_24_filled,
                                  color: ColorPalette.SH_Grey100,
                                )
                              : Icon(
                                  FluentIcons.eye_24_filled,
                                  color: ColorPalette.SH_Grey100,
                                ),
                        ),
                        hidetext,
                        null),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5).w,
                    padding: const EdgeInsets.symmetric(horizontal: 25).w,
                    child: WidgetsModels.customTTF_title(
                        TextString.confirmpassword,
                        null,
                        _confirmnewpasswordController,
                        TextInputType.visiblePassword,
                        Fieldvalidator.validatepassword,
                        Icon(
                          FluentIcons.key_20_regular,
                          color: ColorPalette.SH_Grey100,
                          size: 20.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              hidetext2 = !hidetext2;
                            });
                          },
                          child: hidetext2
                              ? Icon(
                                  FluentIcons.eye_off_24_filled,
                                  color: ColorPalette.SH_Grey100,
                                )
                              : Icon(
                                  FluentIcons.eye_24_filled,
                                  color: ColorPalette.SH_Grey100,
                                ),
                        ),
                        hidetext2,
                        null),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5).w,
                    padding: const EdgeInsets.symmetric(horizontal: 25).w,
                    child: WidgetsModels.customTTF_title(
                        TextString.codepin,
                        const EdgeInsets.only(bottom: 5).w,
                        _pinController,
                        TextInputType.number,
                        Fieldvalidator.validatePinCode,
                        Icon(
                          FluentIcons.lock_shield_24_regular,
                          color: ColorPalette.SH_Grey100,
                        ),
                        null,
                        false,
                        6),
                  ),
                ],
              )),
          if (Fieldvalidator.isPin(_pinController.value.text) &&
              validator.password(_newpasswordController.value.text) &&
              validator.password(_confirmnewpasswordController.value.text) &&
              (_confirmnewpasswordController.value.text ==
                  _newpasswordController.value.text))
            StatefulBuilder(
              builder: (contextbtn, setStatebtn) => GestureDetector(
                  onTap: () async {
                    setStatebtn(() {
                      isStreched = false;
                    });
                    RessetPasswordRequestModel ForgotPassword =
                        RessetPasswordRequestModel(
                            email: widget.email!,
                            otp: _pinController.value.text,
                            password: _newpasswordController.value.text);
                    await Future.delayed(const Duration(seconds: 1));
                    await APISERVICES()
                        .ressetPassword(ForgotPassword)
                        .then((response) => {
                              setStatebtn(() {
                                isStreched = true;
                              }),
                              if (response.message == "success")
                                {
                                  context.pushReplacementNamed(
                                      RoutesName.PasswordChanged),
                                }
                              else if (response.message == "expired")
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      WidgetsModels.Dialog_Message(
                                          "help",
                                          response.message,
                                          "Your otp is expired send another one")),
                                }
                              else if (response.message == "otp incorrect")
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      WidgetsModels.Dialog_Message(
                                          "fail",
                                          response.message,
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
                  child: isStreched
                      ? WidgetsModels.Container_widget(
                          null,
                          50.h,
                          Alignment.center,
                          const EdgeInsets.all(25).w,
                          BoxDecoration(
                            color: ColorPalette.SH_Grey100,
                            borderRadius: BorderRadius.circular(5).r,
                          ),
                          Text(
                            TextString.resetpassword,
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : WidgetsModels.buildSmallButton()),
            )
          else
            WidgetsModels.Container_widget(
                null,
                50.h,
                Alignment.center,
                const EdgeInsets.symmetric(
                  horizontal: 25,
                  vertical: 25,
                ).w,
                BoxDecoration(
                  color: ColorPalette.SH_Grey500,
                  borderRadius: BorderRadius.circular(5).r,
                ),
                Text(
                  TextString.resetpassword,
                  style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700),
                )),
        ]),
      ),
    );
  }
}
