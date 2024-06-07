import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Path.dart';

class Intro3 extends StatefulWidget {
  const Intro3({super.key});

  @override
  State<Intro3> createState() => _Intro3();
}

class _Intro3 extends State<Intro3> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(Path.LogoImg),
            Image.asset(Path.Intro3),
            WidgetsModels.Container_widget(
                280.w,
                60.h,
                Alignment.center,
                null,
                null,
                Text(
                  TextString.community,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 24.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Image.asset(Path.Selected3),
            GestureDetector(
              onTap: () {
                context.pushReplacementNamed(RoutesName.Login);
              },
              child: WidgetsModels.Container_widget(
                  310.w,
                  50.h,
                  Alignment.center,
                  const EdgeInsets.only(bottom: 60).w,
                  BoxDecoration(
                      color: ColorPalette.SH_Grey100,
                      borderRadius: BorderRadius.circular(5).r),
                  Text(
                    TextString.getstarted,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: 17.sp,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
