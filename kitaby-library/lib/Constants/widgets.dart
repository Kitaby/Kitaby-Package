// ignore_for_file: non_constant_identifier_names, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Strings.dart';
import 'package:kitabylib/Constants/Path.dart';

class WidgetsModels {
  static Container Container_widget(
    double? varwidth,
    double? varheight,
    Alignment? varalignment,
    EdgeInsets? varmargin,
    BoxDecoration? vardecoration,
    Widget? w,
  ) {
    return Container(
      width: varwidth,
      height: varheight,
      alignment: varalignment, //A conatiner that have a widget child
      margin: varmargin,
      decoration: vardecoration,
      child: w,
    );
  }
  static TextStyle customtextstyle(Color varcolor, double varsize,
      FontWeight varfontweight, String varfontfamily) {
    return TextStyle(
      color: varcolor,
      fontSize: varsize, //textstyle of a textwidget
      fontWeight: varfontweight,
      fontFamily: varfontfamily,
    );
  }

  static TextFormField customTFF(
      TextEditingController varcontroller,
      TextStyle varstyle,
      AutovalidateMode varavm,
      TextInputType varkt,
      var vali,
      InputDecoration vardecoration,
      bool varobscure,
      int? varlength) {
    return TextFormField(
      controller: varcontroller,
      style: varstyle,
      autovalidateMode: varavm, //TextFormField
      keyboardType: varkt,
      validator: vali,
      decoration: vardecoration,
      cursorColor: ColorPalette.backgroundcolor,
      obscureText: varobscure,
      maxLength: varlength,
    );
  }

  static TextField customTF(
      TextEditingController varcontroller,
      TextStyle varstyle,
      TextInputType varkt,
      InputDecoration vardecoration,
      bool varobscure,
      int? varlength,
      int? vatlines) {
    return TextField(
      controller: varcontroller,
      style: varstyle,
      keyboardType: varkt,
      decoration: vardecoration,
      cursorColor: ColorPalette.SH_Grey100,
      obscureText: varobscure,
      maxLength: varlength,
      maxLines: vatlines,
    );
  }

  static InputDecoration customdecoration1(
      Widget varprefix, Widget? varsuffix) {
    return InputDecoration(
      counterText: '',
      errorStyle: GoogleFonts.montserrat(
          fontSize: 14.sp, color: ColorPalette.Error, fontWeight: FontWeight.w500),
      prefixIcon: Align(
        heightFactor: 1.0.h,
        widthFactor: 1.0.w,
        child: varprefix,
      ),
      suffixIcon: Align(
        heightFactor: 1.0.h,
        widthFactor: 2.0.w,
        child: varsuffix,
      ),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 20, horizontal: 10.0).w,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.backgroundcolor, width: 1.5.w),
        borderRadius: BorderRadius.circular(5).r,
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.Error, width: 1.5.w),
        borderRadius: BorderRadius.circular(5).r,
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.Error, width: 1.5.w),
        borderRadius: BorderRadius.circular(5).r,
      ),
      disabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.backgroundcolor, width: 1.5.w),
        borderRadius: BorderRadius.circular(5).r,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.backgroundcolor, width: 1.5.w),
        borderRadius: BorderRadius.circular(5).r,
      ),
      //Decoration of textformfieldborders
      border: OutlineInputBorder(
        borderSide: BorderSide(color: ColorPalette.backgroundcolor, width: 1.5.w),
        borderRadius: BorderRadius.circular(5).r,
      ),
    );
  }

  static SnackBar Dialog_Message(String type, String info1, String info2) {
    return SnackBar(
      duration: const Duration(seconds: 5),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      clipBehavior: Clip.none,
      elevation: 0,
      content: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.all(16).w,
            height: 100.h,
            decoration: BoxDecoration(
              color: (type == "success")
                  ? ColorPalette.Secondary_Color_Dark
                  : (type == "fail")
                      ? ColorPalette.snackErroColor
                      : (type == "warning")
                          ? ColorPalette.snackWarning
                          : ColorPalette.Primary_Color_Light,
              borderRadius: const BorderRadius.all(Radius.circular(20)).r,
            ),
            child: Row(
              children: [
                const SizedBox(
                  width: 60,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        info1,
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontWeight: FontWeight.w600,
                            fontSize: 24.sp),
                      ),
                      const Spacer(),
                      Text(
                        info2,
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontWeight: FontWeight.w500,
                            fontSize: 15.sp),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
              bottom: 0,
              child: ClipRRect(
                  borderRadius:
                      const BorderRadius.only(bottomLeft: Radius.circular(20)),
                  child: SvgPicture.asset(
                    Path.pathBubble,
                    height: 65.h,
                    width: 60.w,
                    // ignore: deprecated_member_use
                    color: (type == "success")
                        ? ColorPalette.snackBubblesucces
                        : (type == "fail")
                            ? ColorPalette.snackBubbleerror
                            : (type == "warning")
                                ? ColorPalette.snackBubbleWarning
                                : ColorPalette.Primary_Color_Dark,
                  ))),
          if (type == "success")
            Positioned(
              top: -30,
              left: 10,
              child: SvgPicture.asset(
                Path.pathsucces,
                height: 60.h,
              ),
            ),
          if (type == "fail")
            Positioned(
              top: -30,
              left: 10,
              child: SvgPicture.asset(
                Path.pathfail,
                height: 60.h,
              ),
            ),
          if (type == "help")
            Positioned(
              top: -30,
              left: 10,
              child: SvgPicture.asset(
                Path.pathquestion,
                height: 60.h,
              ),
            ),
          if (type == "warning")
            Positioned(
              top: -30,
              left: 10,
              child: SvgPicture.asset(
                Path.pathwarning,
                height: 60.h,
              ),
            ),
        ],
      ),
    );
  }

  static Container customTTF_title(
    String vartitle,
    EdgeInsets? varmargin,
    TextEditingController varcontroller,
    TextInputType varkeybordtype,
    var vali, //
    Widget varprefix,
    Widget? varsuffix,
    bool varobscure,
    int? varlength,
  ) {
    return Container(
      height: 119.h,
      margin: varmargin,
      child: Column(
        children: [
          Container_widget(
              null,
              null,
              Alignment.centerLeft,
              const EdgeInsets.all(10).w,
              null,
              Text(vartitle,
                  style: GoogleFonts.montserrat(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorPalette.backgroundcolor))),
          Container_widget(
              null,
              null,
              null,
              null,
              null,
              customTFF(
                  varcontroller,
                  GoogleFonts.montserrat(
                      fontSize: 15.5.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorPalette.backgroundcolor),
                  AutovalidateMode.onUserInteraction,
                  varkeybordtype,
                  vali,
                  customdecoration1(
                    varprefix,
                    varsuffix,
                  ),
                  varobscure,
                  varlength))
        ],
      ),
    );
  }

  static Container customcard1(
    String vartitle,
    bool varbool,
    var varontap,
  ) {
    return Container(
      width: 80.w,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: BorderSide(
                color: (varbool)
                    ? ColorPalette.Secondary_Color_Orignal
                    : Colors.transparent)),
        child: ListTile(
          onTap: varontap,
          visualDensity: const VisualDensity(vertical: -3),
          title: Text(
            vartitle , 
            style: GoogleFonts.montserrat(
              color: ColorPalette.SH_Grey100,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500
            ),
          ),
          tileColor: ColorPalette.Primary_Color_Dark,
        ),
      ),
    );
  }

  static Container bookcard(
      String vartitle,
      double titlefontsize,
      String varauthor,
      double authorfontsize,
      Color varcolor,
      String varimage,
      double containerwidth,
      double? containerheight,
      double imagewidth,
      double imageheight,
      bool selected,
      String? booktype,
      {int? quantity}
      ) {
    return Container(
      width: containerwidth,
      height: containerheight,
      child: Column(children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:const BorderRadius.all(Radius.circular(10)).r,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:const BorderRadius.all(Radius.circular(10)).r,
                  border: (selected)
                      ? Border.all(
                          width: 3.w, color: ColorPalette.Secondary_Color_Orignal)
                      : null,
                ),
                child: FadeInImage.assetNetwork(
                  placeholder: Path.Logolib, // Before image load
                  image: varimage, // After image load
                  width: imagewidth,
                  height: imageheight,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            if (booktype == 'quantity')
              Positioned(
                  top: 0,
                  right: imagewidth / 7,
                  child: WidgetsModels.Container_widget(
                    imagewidth / 7,
                    imagewidth / 7,
                    Alignment.center,
                    null,
                    BoxDecoration(
                        color: ColorPalette.Secondary_Color_Orignal,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(2))),
                    Text(
                      "$quantity",
                      style: GoogleFonts.montserrat(
                  color:  ColorPalette.SH_Grey100,
                  fontWeight: FontWeight.w500,
                  fontSize:imagewidth / 10),
                    ),
                  )),
          ],
        ),
        //SizedBox(height: imagewidth ),
        WidgetsModels.Container_widget(
            null,
            null,
            Alignment.center,
            null,
            null,
            Text(
              ( vartitle.length>25)? vartitle.substring(0,25)+"...":vartitle,
              style: GoogleFonts.montserrat(
                  color: (selected)
                      ? ColorPalette.Secondary_Color_Orignal
                      : varcolor,
                  fontWeight: FontWeight.w500,
                  fontSize: titlefontsize),
              textAlign: TextAlign.center,
            )),
        //SizedBox(height: imagewidth / 30),
        WidgetsModels.Container_widget(
            null,
            null,
            Alignment.center,
            null,
            null,
            Text(
             ( varauthor.length>25)? varauthor.substring(0,25)+"...":varauthor,
              style: GoogleFonts.montserrat(
                  color: (selected)
                      ? ColorPalette.Secondary_Color_Orignal
                      : varcolor,
                  fontWeight: FontWeight.w400,
                  fontSize: authorfontsize),
              textAlign: TextAlign.center,
            )),
      ]),
    );
  }

  static Container button1(double varwidth, double varheight, Color varcolor,
      IconData? varicon, Color vartitlecolor, String vartitle,{bool? shadow ,bool? border}) {
    return Container(
      width: varwidth,
      height: varheight,
      
      decoration: BoxDecoration(
          color: varcolor,
          border:(border==true)?
           Border.all(
            color: vartitlecolor,
            width: 1.w,
          ):null,
          boxShadow: [
            if(shadow==true)
            BoxShadow(
                color:vartitlecolor,
                blurRadius: 1.0.r,
                spreadRadius: 0.0.r,
                offset:const Offset(1.0, 1.0), // shadow direction: bottom right
            ),
        ],
          
          borderRadius: const BorderRadius.all(Radius.circular(5)).r),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        if(varicon!=null)
        Icon(
          varicon,
          size: (varheight / 2).sp,
          color: vartitlecolor,
        ),
        Text(
          vartitle,
          style: GoogleFonts.montserrat(
              color: vartitlecolor,
              fontWeight: FontWeight.w700,
              fontSize: (varwidth / 15).sp),
        )
      ]),
    );
  }

  static Container titlenr() {
    return WidgetsModels.Container_widget(
      null,
      100.h,
      Alignment.center,
      null,
      BoxDecoration(color: ColorPalette.Primary_Color_Original),
      Text(
        TextString.title,
        style: GoogleFonts.montserrat(
            color: ColorPalette.SH_Grey100,
            fontSize: 32.sp,
            fontWeight: FontWeight.w800),
      ),
    );
  }

  static Container title(BuildContext context) {
    return WidgetsModels.Container_widget(
        null,
        80.h,
        Alignment.center,
        null,
        BoxDecoration(color: ColorPalette.Primary_Color_Original),
        Row(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 104).w,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back_rounded,
                    size: 30.sp,
                    color: ColorPalette.SH_Grey100,
                  )),
            ),
            Text(
              TextString.title,
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w800),
            ),
          ],
        ));
  }

  static Container searchbar(
      TextEditingController varcontroller,
      double? varwidth,
      String varhinttext,
      Widget? varprefix,
      Widget? varsuffix,
      Function(String) varonsubmitted) {
    return Container(
      width: varwidth,
      child: TextField(
        textAlignVertical: TextAlignVertical.center,
        onSubmitted: varonsubmitted,
        controller: varcontroller,
        cursorColor: ColorPalette.SH_Grey300,
        decoration: InputDecoration(
          hintText: varhinttext,
          filled: true,
          fillColor: ColorPalette.verylightgrey,
          focusedBorder: OutlineInputBorder(
              borderSide:const BorderSide(color: Colors.transparent),
              borderRadius:const BorderRadius.all(Radius.circular(50)).r),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: ColorPalette.SH_Grey300),
              borderRadius:const BorderRadius.all(Radius.circular(50)).r),
          enabledBorder:OutlineInputBorder(
              borderSide: BorderSide(color: ColorPalette.SH_Grey300,width: 0.5.w),
              borderRadius:const BorderRadius.all(Radius.circular(50)).r),
          prefixIcon: Align(
            heightFactor: 1.0.h,
            widthFactor: 1.0.w,
            child: varprefix,
          ),
          suffixIcon: Align(
            heightFactor: 1.0.h,
            widthFactor: 2.0.w,
            child: varsuffix,
          ),
          
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 10.0).w,
        ),
      ),
    );
  }

  static Container buildSmallButton() => WidgetsModels.Container_widget(
        50.w,
        50.h,
        Alignment.center,
        const EdgeInsets.all(25).w,
        BoxDecoration(
          shape: BoxShape.circle,
          color: ColorPalette.backgroundcolor,
        ),
        SizedBox(
          height: 25.h,
          width: 25.w,
          child: Center(
            child: CircularProgressIndicator(
              color: ColorPalette.SH_Grey100,
            ),
          ),
        ),
      );
}
