import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:lottie/lottie.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Path.dart';
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
    Timer(const Duration(seconds: 7, milliseconds: 500, microseconds: 200),
        () => context.pushReplacementNamed(RoutesName.Login));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Lottie.asset(
                Path.PasswordChanged, // Replace with the path to your Lottie JSON file
                fit: BoxFit.cover,
                width: 200.w, // Adjust the width and height as needed
                height: 200.h,
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Column(
              children: [
                Text(
                  TextString.resetpasswordcompleted,
                  style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      color: ColorPalette.SH_Grey100),
                ),
                SizedBox(
                  height: 7.h,
                ),
                Text(
                  TextString.canlogin,
                  style: GoogleFonts.montserrat(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.SH_Grey100),
                ),
                SizedBox(
                  height: 100.h,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
