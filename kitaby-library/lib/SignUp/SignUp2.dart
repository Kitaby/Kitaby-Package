import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/Constants/validator.dart';
import 'package:kitabylib/SignUp/SignUp3.dart';
import 'package:regexed_validator/regexed_validator.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup2 extends StatefulWidget {
  const Signup2({super.key, required this.phone, required this.name});
  final String phone;
  final String name;
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
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: Container(
          alignment: Alignment.center,
          decoration:const BoxDecoration(
            image : DecorationImage(image: AssetImage("assets/images/Shape.png"), fit: BoxFit.cover),
          ),
          child: Container(
            height: 665.h,
            width: 456.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24).r,
              color: ColorPalette.SH_Grey100,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25 , vertical: 10).w,
            child: ListView(
              physics: const ClampingScrollPhysics(),
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
                    20.w,
                    25.h,
                    Alignment.center,
                    const EdgeInsets.only(bottom: 15).w,
                    null,
                    Text("Sign to continue",
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.backgroundcolor,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w300))),
                WidgetsModels.Container_widget(null, 30.h, Alignment.center, null,
                    null, Image.asset(Path.Selected2)),
                Form(
                    key: Signup,
                    child: Column(
                      children: [
                        WidgetsModels.customTTF_title(
                            "Email Adress",
                            null,
                            _emailController,
                            TextInputType.emailAddress,
                            Fieldvalidator.validateemail,
                            Icon(
                              FluentIcons.mail_24_regular,
                              color: ColorPalette.backgroundcolor,
                            ),
                            null,
                            false,
                            null),
                        WidgetsModels.customTTF_title(
                            "Password",
                            null,
                            _passwordController,
                            TextInputType.text,
                            Fieldvalidator.validatepassword,
                            Icon(
                              FluentIcons.key_24_regular,
                              color: ColorPalette.backgroundcolor,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hideText1 = !hideText1;
                                  });
                                },
                                child: hideText1
                                    ? Icon(FluentIcons.eye_off_24_filled,
                                        color: ColorPalette.backgroundcolor)
                                    : Icon(FluentIcons.eye_24_filled,
                                        color: ColorPalette.backgroundcolor)),
                            hideText1,
                            null),
                        WidgetsModels.customTTF_title(
                            "Confirm Password",
                            null,
                            _confirmPasswordController,
                            TextInputType.text,
                            Fieldvalidator.validatepassword,
                            Icon(
                              FluentIcons.key_24_regular,
                              color: ColorPalette.backgroundcolor,
                            ),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    hideText2 = !hideText2;
                                  });
                                },
                                child: hideText2
                                    ? Icon(FluentIcons.eye_off_24_filled,
                                        color: ColorPalette.backgroundcolor)
                                    : Icon(FluentIcons.eye_24_filled,
                                        color: ColorPalette.backgroundcolor)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Signup3(
                          phone:  widget.phone.substring(1), 
                          email: _emailController.value.text, 
                          password: _passwordController.value.text, 
                          name: widget.name
                        )
                      )
                      );
                    },
                  child: WidgetsModels.Container_widget(
                      50.w,
                      45.h,
                      Alignment.center,
                      const EdgeInsets.symmetric(horizontal: 30 , vertical: 15).w,
                      BoxDecoration(
                          color: ColorPalette.backgroundcolor,
                          borderRadius: BorderRadius.circular(5).r),
                      Text("Next",
                          style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey100,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600))),
                )
                else
                  WidgetsModels.Container_widget(
                      50.w,
                      45.h,
                      Alignment.center,
                      const EdgeInsets.symmetric(horizontal: 30 , vertical: 15).w,
                      BoxDecoration(
                          color: ColorPalette.SH_Grey300,
                          borderRadius: BorderRadius.circular(5).r),
                      Text("Next",
                          style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey100,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
