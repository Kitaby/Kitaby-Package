import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/AppIntro/Intro-2.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Strings.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:kitabylib/Login.dart';

class Intro1 extends StatefulWidget {
  const Intro1({super.key});

  @override
  State<Intro1> createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image : DecorationImage(image: AssetImage("assets/images/Shape.png"), fit: BoxFit.cover),
        ),
        child: Container(
           height: 665.h,
            width: 456.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24).r,
            color: Colors.white,
            ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset(Path.Logolib),
            SvgPicture.asset(Path.Intro1 ,width: 300.w,),
            WidgetsModels.Container_widget(
                282.w,
                70.h,
                Alignment.center,
                null,
                null,
                Text(
                  "Control your library via a dashboard",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey900,
                    fontSize: 24.sp,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w500,
                  ),
                )),
            Image.asset(Path.Selected1,width: 150.w,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  Login(),));
                  },
                  child: WidgetsModels.Container_widget(
                    50.w,
                    21.h,
                    Alignment.center,
                    const EdgeInsets.only(left: 48).w,
                    BoxDecoration(borderRadius: BorderRadius.circular(30).r),
                    Text(
                      TextString.skip,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey900,
                        fontSize: 17.sp,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Intro2(),));
                  },
                  child: WidgetsModels.Container_widget(
                      100.w,
                      37.h,
                      Alignment.center,
                      const EdgeInsets.only(right: 48).w,
                      BoxDecoration(
                          color: ColorPalette.Primary_Color_Dark,
                          borderRadius: BorderRadius.circular(30)),
                      Text(
                        TextString.next,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 17.sp,
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                ),
              ]
             )
            ]
          )
         )
        )
      ) 
    );
  }
}