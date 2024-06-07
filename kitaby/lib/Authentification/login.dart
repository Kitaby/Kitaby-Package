// ignore_for_file: camel_case_types
import 'dart:async';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/validator.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../Constants/widgets.dart';
import '../Constants/Colors.dart';
import '../Constants/Path.dart';
import '../models/Authentification/Login/login_request_model.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => loginstate();
}

class loginstate extends State<Login> {
  static bool state = false;
  static bool state2 = false;
  static bool hidetext = true;
  static bool isStreched = true;
  static bool isAnimated = true;
  static GlobalKey<FormState> login = GlobalKey();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorPalette.backgroundcolor,
        body: Container(
          padding: const EdgeInsets.only(top: 60).w,
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              WidgetsModels.Container_widget(
                  null,
                  null,
                  Alignment.center,
                  const EdgeInsets.only(bottom: 20).w,
                  null,
                  Image.asset(Path.LogoImg)),
              WidgetsModels.Container_widget(
                  null,
                  40.h,
                  Alignment.center,
                  null,
                  null,
                  Text(
                    TextString.welcomeback,
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey100,
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600),
                  )),
              WidgetsModels.Container_widget(
                  null,
                  25.h,
                  Alignment.center,
                  const EdgeInsets.only(bottom: 20).w,
                  null,
                  Text(
                    TextString.signin,
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey100,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w300),
                  )),
              Form(
                key: login,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 15).w,
                  padding: const EdgeInsets.symmetric(horizontal: 25).w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetsModels.customTTF_title(
                          TextString.emailadress,
                          const EdgeInsets.only(bottom: 10).h,
                          _emailController,
                          TextInputType.emailAddress,
                          Fieldvalidator.validateemail,
                          Icon(
                            FluentIcons.mail_24_regular,
                            color: ColorPalette.SH_Grey100,
                            size: 20.sp,
                          ),
                          null,
                          false,
                          null),
                      WidgetsModels.customTTF_title(
                          TextString.password,
                          const EdgeInsets.only(bottom: 15).w,
                          _passwordController,
                          TextInputType.visiblePassword,
                          Fieldvalidator.validatepassword,
                          Icon(
                            FluentIcons.key_24_regular,
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
                      WidgetsModels.Container_widget(
                          null,
                          null,
                          Alignment.centerRight,
                          null,
                          null,
                          GestureDetector(
                            onTap: () {
                              String oldmail = validator
                                      .email(_emailController.value.text)
                                  ? _emailController.value.text
                                  : ' '; //if the email is valid it will be transmitted to forgotyourpassword page
                              context.pushNamed(RoutesName.Forgotpassword1,
                                  pathParameters: {'oldmail': oldmail});
                            },
                            child: Text(
                              TextString.forgotyourpassword,
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey100,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
              if (validator.email(_emailController.value.text) &&
                  validator.password(_passwordController.value.text))
                StatefulBuilder(
                    builder: (contextbtn, setStatebtn) => GestureDetector(
                        onTap: () async {
                          setStatebtn(() {
                            isStreched = false;
                          });
                          LoginRequestModel login = LoginRequestModel(
                              email: _emailController.value.text,
                              password: _passwordController.value.text);
                          await Future.delayed(const Duration(seconds: 1));
                          await APISERVICES().login(login).then((response) => {
                                setStatebtn(() {
                                  isStreched = true;
                                }),
                                if (response.message == "success")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        WidgetsModels.Dialog_Message(
                                            "success",
                                            "Login successed",
                                            "Welcome back to kitaby ${response.username}")),
                                    Timer(const Duration(seconds: 5), () {
                                      context.pushReplacementNamed(
                                          RoutesName.Home,
                                          pathParameters: {
                                            "token": response.token!,
                                            "index": "0"
                                          });
                                    })
                                  }
                                else if (response.message == "Not verified")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        WidgetsModels.Dialog_Message(
                                            "help",
                                            response.message,
                                            "Please verify your email to use Kitaby")),
                                  }
                                else if (response.message ==
                                    "Wrong Credentials")
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        WidgetsModels.Dialog_Message(
                                            "fail",
                                            response.message,
                                            "Your email or password was incorrect please retry")),
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
                                  TextString.login,
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey900,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : WidgetsModels.buildSmallButton()))
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
                      TextString.login,
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w700),
                    )),
              WidgetsModels.Container_widget(
                  null,
                  null,
                  Alignment.center,
                  const EdgeInsets.symmetric(horizontal: 25).w,
                  null,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        TextString.donthaveaccount,
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.pushReplacementNamed(RoutesName.Signup1);
                        },
                        child: Text(
                          TextString.signup,
                          style: GoogleFonts.montserrat(
                              color: Colors.lightBlue,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
