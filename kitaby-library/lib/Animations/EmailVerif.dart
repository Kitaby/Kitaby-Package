import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/Login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailVerif extends StatefulWidget {
  const EmailVerif({super.key});

  @override
  State<EmailVerif> createState() => _EmailVerifState();
}

class _EmailVerifState extends State<EmailVerif> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 7, milliseconds: 500, microseconds: 200),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => const Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(image:  AssetImage("assets/images/Shape.png"), fit: BoxFit.cover)
        ),
        child: Container(
          height: 665.h,
          width: 456.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: ColorPalette.SH_Grey100
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Lottie.asset(
                  Path.EmailAnime, // Replace with the path to your Lottie JSON file
                  fit: BoxFit.cover,
                  width: 200.w, // Adjust the width and height as needed
                  height: 200.h,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Text(
                    "An Email is Sent",
                    style: GoogleFonts.montserrat(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorPalette.SH_Grey900),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    "Please Verify your mailBox",
                    style: GoogleFonts.montserrat(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        color: ColorPalette.SH_Grey900),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
