// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';

class ProfileWidget {
  static DropdownMenu customdropdownmenu(
      String varlabeltext,
      double varwidth,
      double varmenuheight,
      TextEditingController varcontroller,
      List<DropdownMenuEntry> varitems,
      Function(dynamic) fctonselected) {
    return DropdownMenu(
      inputDecorationTheme: InputDecorationTheme(
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              borderSide:
                  BorderSide(width: 1, color: ColorPalette.SH_Grey100))),
      menuStyle: MenuStyle(
        elevation: const MaterialStatePropertyAll(0),
        backgroundColor: MaterialStatePropertyAll(ColorPalette.backgroundcolor),
      ),
      label: Text(
        varlabeltext,
        style: GoogleFonts.montserrat(
            color: ColorPalette.SH_Grey100,
            fontSize: 16,
            fontWeight: FontWeight.w400),
      ),

      width: varwidth, //315
      selectedTrailingIcon: Icon(
        Icons.arrow_drop_up,
        size: 30,
        color: ColorPalette.SH_Grey100,
      ),
      trailingIcon: Icon(
        Icons.arrow_drop_down,
        size: 30,
        color: ColorPalette.SH_Grey100,
      ),
      textStyle: GoogleFonts.montserrat(
          color: ColorPalette.SH_Grey100,
          fontSize: 16,
          fontWeight: FontWeight.w400),
      menuHeight: varmenuheight, //300
      controller: varcontroller,
      dropdownMenuEntries:
          varitems, //varitemlist.map(fctbuildmenuitem).toList()
      onSelected: fctonselected,
    );
  }
}
