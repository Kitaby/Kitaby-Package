import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/AppIntro/Intro-1.dart';
import 'package:kitabylib/Login.dart';
import 'package:kitabylib/Mainscreen.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/Colors.dart';
import '../Constants/Strings.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/Path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String? token;
  Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    getToken();
    super.initState();
    Timer(
        const Duration(seconds: 3, milliseconds: 215, microseconds: 5),
        () => (token == null)
            ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Intro1(),))
            : (token == "")
                ? Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Login ()))
                : Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Mainscreen(token: token,))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image : DecorationImage(image: AssetImage("assets/images/Shape.png"), fit: BoxFit.cover),
        ),
        child: Container(
           height: 650.h,
            width: 456.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24).r,
            color: Colors.white,
            ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    Path.LogoAnime, // Replace with the path to your Lottie JSON file
                    fit: BoxFit.cover,
                    width: 400.w, // Adjust the width and height as needed
                    height: 400.h,
                  ),
                ),
                Center(
                  child: AnimatedTextKit(animatedTexts: [
                    TyperAnimatedText(
                      TextString.title,
                      textStyle: GoogleFonts.montserrat(
                          fontSize: 64.sp,
                          fontWeight: FontWeight.w700,
                          color: ColorPalette.backgroundcolor),
                      speed: const Duration(milliseconds: 210),
                      curve: Curves.easeIn,
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
