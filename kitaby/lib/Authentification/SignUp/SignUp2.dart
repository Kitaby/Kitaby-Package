// ignore_for_file: file_names, non_constant_identifier_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/validator.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup2 extends StatefulWidget {
  final String? name;
  final String? phone;
  const Signup2({super.key, required this.name, required this.phone});
  @override
  State<Signup2> createState() => Signup2state();
}

class Signup2state extends State<Signup2> {
  static bool state = false;
  static bool state2 = false;
  static bool state3 = false;
  static bool hideText1 = true;
  static bool hideText2 = true;
  static GlobalKey<FormState> Signup = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      final isEmailValid = validator.email(_emailController.value.text);
      if (isEmailValid != state) {
        setState(() {
          state = isEmailValid;
        });
      }
    });

    _passwordController.addListener(() {
      final ispasswordValid =
          validator.password(_passwordController.value.text);
      if (ispasswordValid != state2) {
        setState(() {
          state2 = ispasswordValid;
        });
      }
    });

    _confirmPasswordController.addListener(() {
      final ispasswordValid =
          validator.password(_confirmPasswordController.value.text);
      if (ispasswordValid != state3) {
        setState(() {
          state3 = ispasswordValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10).w,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              WidgetsModels.Container_widget(
                null,
                null,
                Alignment.topLeft,
                null,
                null,
                GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    child: Icon(
                      Icons.arrow_back_rounded,
                      size: 30.sp,
                      color: ColorPalette.SH_Grey100,
                    )),
              ),
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
                  null, null, Image.asset(Path.Selected2)),
              Form(
                  key: Signup,
                  child: Column(
                    children: [
                      WidgetsModels.customTTF_title(
                          TextString.emailadress,
                          const EdgeInsets.only(top: 25).w,
                          _emailController,
                          TextInputType.emailAddress,
                          Fieldvalidator.validateemail,
                          Icon(
                            FluentIcons.mail_24_regular,
                            color: ColorPalette.SH_Grey100,
                          ),
                          null,
                          false,
                          null),
                      WidgetsModels.customTTF_title(
                          TextString.password,
                          null,
                          _passwordController,
                          TextInputType.text,
                          Fieldvalidator.validatepassword,
                          Icon(
                            FluentIcons.key_24_regular,
                            color: ColorPalette.SH_Grey100,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  hideText1 = !hideText1;
                                });
                              },
                              child: hideText1
                                  ? Icon(FluentIcons.eye_off_24_filled,
                                      color: ColorPalette.SH_Grey100)
                                  : Icon(FluentIcons.eye_24_filled,
                                      color: ColorPalette.SH_Grey100)),
                          hideText1,
                          null),
                      WidgetsModels.customTTF_title(
                          TextString.confirmpassword,
                          const EdgeInsets.only(bottom: 30).w,
                          _confirmPasswordController,
                          TextInputType.text,
                          Fieldvalidator.validatepassword,
                          Icon(
                            FluentIcons.key_24_regular,
                            color: ColorPalette.SH_Grey100,
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  hideText2 = !hideText2;
                                });
                              },
                              child: hideText2
                                  ? Icon(FluentIcons.eye_off_24_filled,
                                      color: ColorPalette.SH_Grey100)
                                  : Icon(FluentIcons.eye_24_filled,
                                      color: ColorPalette.SH_Grey100)),
                          hideText2,
                          null),
                    ],
                  )),
              if (validator.email(_emailController.value.text) &&
                  validator.password(_passwordController.value.text) &&
                  validator.password(_confirmPasswordController.value.text) &&
                  (_confirmPasswordController.text == _passwordController.text))
                GestureDetector(
                  onTap: () {
                    context.pushNamed(RoutesName.Signup3, pathParameters: {
                      "name": widget.name!,
                      "phone": widget.phone!,
                      "email": _emailController.value.text,
                      "password": _passwordController.value.text,
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
                              fontWeight: FontWeight.w600))),
                )
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
            ],
          ),
        ),
      ),
    );
  }
}
