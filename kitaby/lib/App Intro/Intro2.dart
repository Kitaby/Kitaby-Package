import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Path.dart';

class Intro2 extends StatefulWidget {
  const Intro2({super.key});

  @override
  State<Intro2> createState() => _Intro2();
}

class _Intro2 extends State<Intro2> {
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
            Image.asset(Path.Intro2),
            WidgetsModels.Container_widget(
                280.w,
                65.h,
                Alignment.center,
                null,
                null,
                Text(
                  TextString.trade,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 24.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Image.asset(Path.Selected2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pushReplacementNamed(RoutesName.Login);
                  },
                  child: WidgetsModels.Container_widget(
                    40.w,
                    25.h,
                    Alignment.center,
                    const EdgeInsets.only(left: 48).w,
                    BoxDecoration(borderRadius: BorderRadius.circular(30).r),
                    Text(
                      TextString.skip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey100,
                        fontSize: 17.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    context.pushReplacementNamed(RoutesName.Intro3);
                  },
                  child: WidgetsModels.Container_widget(
                      87.w,
                      37.h,
                      Alignment.center,
                      const EdgeInsets.only(right: 48).w,
                      BoxDecoration(
                          color: ColorPalette.SH_Grey100,
                          borderRadius: BorderRadius.circular(30).r),
                      Text(
                        TextString.next,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: 17.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
