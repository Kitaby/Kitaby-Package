import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/Login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';

class PasswordChanged extends StatefulWidget {
  const PasswordChanged({super.key});

  @override
  State<PasswordChanged> createState() => _PasswordChangedState();
}

class _PasswordChangedState extends State<PasswordChanged> {
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
                  Path.PasswordChanged, // Replace with the path to your Lottie JSON file
                  fit: BoxFit.cover,
                  width: 250.w, // Adjust the width and height as needed
                  height: 250.h,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                children: [
                  Text(
                    "Reset Password Completed",
                    style: GoogleFonts.montserrat(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: ColorPalette.SH_Grey900),
                  ),
                  const SizedBox(
                    height: 7,
                  ),
                  Text(
                    "You can now login with your account ",
                    style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
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