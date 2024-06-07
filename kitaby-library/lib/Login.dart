import 'dart:async';
import 'package:kitabylib/Constants/Strings.dart';
import 'package:kitabylib/Mainscreen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/validator.dart';
import 'package:kitabylib/Forgotyourpassword/forgotyourpassword.dart';
import 'package:kitabylib/SignUp/SignUp1.dart';
import 'package:kitabylib/models/api_services.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'Constants/widgets.dart';
import 'Constants/Colors.dart';
import 'Constants/Path.dart';
import 'models/auth/login_request_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  static bool state = false;
  static bool state2 = false;
  static bool hidetext = true;
  static bool isStreched = true;

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
      body: Container(
        alignment: Alignment.center,
        decoration:const BoxDecoration(
          image : DecorationImage(image: AssetImage("assets/images/Shape.png"), fit: BoxFit.cover),
        ),
        child: Container(
          height: 650.h,
          width: 456.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24).r,
          color: ColorPalette.SH_Grey100,
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              WidgetsModels.Container_widget(
                null,
                null,
                Alignment.center,
                const EdgeInsets.only(bottom: 20 , top: 20).w,
                null,
                Image.asset(Path.Logolib)
              ),
              WidgetsModels.Container_widget(
                null,
                40.h,
                Alignment.center,
                null,
                null,
                Text(
                  'Welcome Back',
                  style: GoogleFonts.montserrat(color: ColorPalette.backgroundcolor, fontSize: 30.sp, fontWeight: FontWeight.w600),
                )
              ),
              WidgetsModels.Container_widget(
                null,
                25.h,
                Alignment.center,
                null,
                null,
                Text(
                  'Login to continue',
                  style: GoogleFonts.montserrat(color: ColorPalette.backgroundcolor, fontSize: 20.sp, fontWeight: FontWeight.w300),
                )
              ),
              Form(
                key: login,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20).w,
                  padding: const EdgeInsets.symmetric(horizontal: 25).w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetsModels.customTTF_title(
                        'Email Adress',
                        null,
                        _emailController,
                        TextInputType.emailAddress,
                        Fieldvalidator.validateemail,
                        Icon(
                          FluentIcons.mail_24_regular,
                          color: ColorPalette.backgroundcolor,
                          size: 20.sp,
                        ),
                        null,
                        false,
                        null
                      ),
                      WidgetsModels.customTTF_title(
                        'Password',
                        null,
                        _passwordController,
                        TextInputType.visiblePassword,
                        Fieldvalidator.validatepassword,
                        Icon(
                          FluentIcons.key_24_regular,
                          color: ColorPalette.backgroundcolor,
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
                              color: ColorPalette.SH_Grey900,
                            )
                          : Icon(
                              FluentIcons.eye_24_filled,
                              color: ColorPalette.SH_Grey900,
                            ),
                        ),
                        hidetext,
                        null
                      ),
                      WidgetsModels.Container_widget(
                        null,
                        null,
                        Alignment.centerRight,
                        null,
                        null,
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Forgotyourpassword(
                                  oldmail: validator.email(
                                    _emailController.value.text
                                  )
                                  ? _emailController.value.text
                                  : ''
                                ),
                              )
                            ); //if the email is valid it will be transmitted to forgotyourpassword page
                          },
                          child: Text(
                            'Forgot your password?',
                            style: GoogleFonts.montserrat(
                              color: ColorPalette.backgroundcolor,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500),
                          ),
                        )
                      ),
                      if (validator.email(_emailController.value.text) && validator.password(_passwordController.value.text))
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
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => Mainscreen(token: response.token,),),
                                      );
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
                                  color: ColorPalette.backgroundcolor,
                                  borderRadius: BorderRadius.circular(5).r,
                                ),
                                Text(
                                  TextString.login,
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey100,
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
                        const EdgeInsets.all(25).w,
                        BoxDecoration(
                          color: ColorPalette.SH_Grey300,
                          borderRadius: BorderRadius.circular(5).r,
                        ),
                        Text(
                          'Log in',
                          style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w700
                          ),
                        )
                      ),
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
                        'Dont Have an account ? ',
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.backgroundcolor,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>const SignUp1(),));
                        },
                        child: Text(
                          'SignUp',
                          style: GoogleFonts.montserrat(
                              color: Colors.lightBlue,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}