// ignore_for_file: file_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Exchange/User-Exchange.dart';
import 'package:kitaby/Filters/CategoriesBottomSheet.dart';
import 'package:kitaby/Filters/WillayaBottomSheet.dart';

class FilterBottomSheet extends StatefulWidget {
  final Function(String, List<String>, List<String>) search;
  
  final String name;
  const FilterBottomSheet(
      {super.key, required this.search, required this.name});

  @override
  // ignore: library_private_types_in_public_api
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

// ignore: camel_case_types
enum staroptions { oneandup, threeandup, fivestars }

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  staroptions starvalue = staroptions.oneandup;
  bool categoriesfocus = false;
  List<String>? willayaselected = [];
  List<String>? categoriesselected = [];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 40.h,
            margin: const EdgeInsets.symmetric(vertical: 20).w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Icon(
                    FluentIcons.dismiss_24_regular,
                    color: ColorPalette.SH_Grey100,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                    height: 30.h,
                    child: Text(
                      'Filters',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      categoriesselected!.clear();
                      willayaselected!.clear();
                      starvalue = staroptions.oneandup;
                    });
                  },
                  child: SizedBox(
                      height: 20.h,
                      child: Text(
                        'Reset',
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.Secondary_Color_Light,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).w,
            child: GestureDetector(
              child: WidgetsModels.Container_widget(
                null,
                45.h,
                Alignment.center,
                null,
                BoxDecoration(
                  color: ColorPalette.SH_Grey100,
                  borderRadius: BorderRadius.circular(5),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 15.h,
                    ),
                    Icon(
                      FluentIcons.search_20_regular,
                      color: ColorPalette.SH_Grey900,
                    ),
                    SizedBox(
                      width: 15.h,
                    ),
                    Text(
                      'Search For Categories',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  isDismissible: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                  ),
                  backgroundColor: ColorPalette.Primary_Color_Dark,
                  context: context,
                  builder: (context) => CategoriesBottomSheet(
                    oldcategories:
                        (categoriesselected == null) ? [] : categoriesselected!,
                  ),
                ).then((value) {
                  setState(() {
                    categoriesselected = value;
                  });
                });
              },
            ),
          ),
          if (categoriesselected != null && categoriesselected!.isNotEmpty)
            StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 40.h,
                  margin: const EdgeInsets.all(10).w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: (categoriesselected == null)
                        ? 0
                        : categoriesselected!.length,
                    itemBuilder: (context, index) {
                      if (categoriesselected != null) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5).w,
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Icon(
                                  FluentIcons.dismiss_16_regular,
                                  color: ColorPalette.SH_Grey900,
                                  size: 14.sp,
                                ),
                                Text(categoriesselected![index],
                                    style: GoogleFonts.montserrat(
                                        color: ColorPalette.SH_Grey900,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            shape: StadiumBorder(
                                side:
                                    BorderSide(color: ColorPalette.SH_Grey100)),
                            selected: true,
                            selectedColor: ColorPalette.SH_Grey100,
                            onSelected: (value) {
                              setState(() {
                                categoriesselected!.removeAt(index);
                              });
                            },
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10).w,
            child: GestureDetector(
              child: WidgetsModels.Container_widget(
                null,
                45.h,
                Alignment.center,
                null,
                BoxDecoration(
                  color: ColorPalette.SH_Grey100,
                  borderRadius: BorderRadius.circular(5),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 15.w,
                    ),
                    Icon(
                      FluentIcons.search_20_regular,
                      color: ColorPalette.SH_Grey900,
                    ),
                    SizedBox(
                      width: 15.w,
                    ),
                    Text(
                      'Search For Willaya',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet<dynamic>(
                  isScrollControlled: true,
                  isDismissible: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                        top: const Radius.circular(50.0).r),
                  ),
                  backgroundColor: ColorPalette.Primary_Color_Dark,
                  context: context,
                  builder: (context) => WillayaBottomSheet(
                    oldwillayas:
                        (willayaselected == null) ? [] : willayaselected!,
                  ),
                ).then((value) {
                  setState(() {
                    willayaselected = value;
                  });
                });
              },
            ),
          ),
          if (willayaselected != null && willayaselected!.isNotEmpty)
            StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  height: 40.h,
                  margin: const EdgeInsets.all(10).w,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        (willayaselected == null) ? 0 : willayaselected!.length,
                    itemBuilder: (context, index) {
                      if (willayaselected != null) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5).w,
                          child: ChoiceChip(
                            label: Row(
                              children: [
                                Icon(
                                  FluentIcons.dismiss_16_regular,
                                  color: ColorPalette.SH_Grey900,
                                  size: 14.sp,
                                ),
                                Text(willayaselected![index],
                                    style: GoogleFonts.montserrat(
                                        color: ColorPalette.SH_Grey900,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600)),
                              ],
                            ),
                            shape: StadiumBorder(
                                side:
                                    BorderSide(color: ColorPalette.SH_Grey100)),
                            selected: true,
                            selectedColor: ColorPalette.SH_Grey100,
                            onSelected: (value) {
                              setState(() {
                                willayaselected!.removeAt(index);
                              });
                            },
                          ),
                        );
                      }
                      return null;
                    },
                  ),
                );
              },
            ),
          Container(
            color: ColorPalette.SH_Grey100,
            height: 1,
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.all(20).w,
            child: Text(
              'Customer Review',
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600),
            ),
          ),
          ListTile(
            leading: WidgetsModels.rating(21, 1, true, 0, null),
            title: Text(
              "    1 & UP",
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => ColorPalette.SH_Grey100),
              value: staroptions.oneandup,
              groupValue: starvalue,
              onChanged: (staroptions? value) {
                setState(() {
                  starvalue = value!;
                });
              },
            ),
          ),
          ListTile(
            leading: WidgetsModels.rating(21, 3, true, 0, null),
            title: Text(
              "    3 & UP",
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => ColorPalette.SH_Grey100),
              value: staroptions.threeandup,
              groupValue: starvalue,
              onChanged: (staroptions? value) {
                setState(() {
                  starvalue = value!;
                });
              },
            ),
          ),
          ListTile(
            leading: WidgetsModels.rating(21, 5, true, 0, null),
            title: Text(
              "    5 stars",
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400),
            ),
            trailing: Radio(
              fillColor: MaterialStateColor.resolveWith(
                  (states) => ColorPalette.SH_Grey100),
              value: staroptions.fivestars,
              groupValue: starvalue,
              onChanged: (staroptions? value) {
                setState(() {
                  starvalue = value!;
                });
              },
            ),
          ),
          GestureDetector(
              onTap: () {
                userexchangestate.focus.unfocus();
                widget.search(
                    widget.name, categoriesselected!, willayaselected!);
                context.pop();
                
              },
              child: WidgetsModels.Container_widget(
                null,
                45.h,
                Alignment.center,
                const EdgeInsets.symmetric(horizontal: 70, vertical: 25).w,
                BoxDecoration(
                  color: ColorPalette.SH_Grey100,
                  borderRadius: BorderRadius.circular(5).r,
                ),
                Text(
                  'Done',
                  style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700),
                ),
              ))
        ],
      ),
    );
  }
}
