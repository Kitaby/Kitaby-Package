// ignore_for_file: file_names

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:flutter/material.dart';
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
  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  @override
  void initState() {
    super.initState();
    getToken().then((value) => {
          Timer(
              const Duration(seconds: 2, milliseconds: 400),
              () => (token == null)
                  ? context.pushReplacementNamed(RoutesName.Intro1)
                  : (token == "")
                      ? context.pushReplacementNamed(RoutesName.Login)
                      : context.pushReplacementNamed(RoutesName.Home,
                          pathParameters: {"token": token!, "index": "0"}))
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: Center(
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
                      color: ColorPalette.SH_Grey100),
                  speed: const Duration(milliseconds: 210),
                  curve: Curves.easeIn,
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
