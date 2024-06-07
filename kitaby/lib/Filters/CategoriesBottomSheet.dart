// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';

class CategoriesBottomSheet extends StatefulWidget {
  final List<String> oldcategories;

  const CategoriesBottomSheet({super.key, required this.oldcategories});

  @override
  _CategoriesBottomSheetState createState() => _CategoriesBottomSheetState();
}

class _CategoriesBottomSheetState extends State<CategoriesBottomSheet> {
  List<String> categories = [
    "mystery",
    "biography",
    "history",
    "drama",
    "fiction",
    "romance",
    "adventure",
    "horror",
    "comedy",
    "science",
    "philosophy",
    "religious"
  ];

  List<String> selected2 = [];

  @override
  void initState() {
    super.initState();
    selected2 = widget.oldcategories;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 550.h,
      child: Wrap(
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
                    Navigator.pop(context, []);
                  },
                ),
                SizedBox(
                    height: 30.h,
                    child: Text(
                      'Categories',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, selected2);
                  },
                  child: SizedBox(
                      height: 20.h,
                      child: Text(
                        'Done',
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.Secondary_Color_Light,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20).w,
            height: 600.h,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, crossAxisSpacing: 25, childAspectRatio: 2),
              scrollDirection: Axis.vertical,
              itemCount: categories.length,
              itemBuilder: (context, i) {
                return StatefulBuilder(
                  builder: (context, setStatecat) {
                    return ChoiceChip(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!selected2.contains(categories[i]))
                            Icon(
                              FluentIcons.add_16_regular,
                              color: ColorPalette.Secondary_Color_Orignal,
                              size: 18.sp,
                            ),
                          Text(
                            categories[i],
                            style: GoogleFonts.montserrat(
                                color: (selected2.contains(categories[i]))
                                    ? ColorPalette.SH_Grey900
                                    : ColorPalette.SH_Grey100,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          if (selected2.contains(categories[i]))
                            Icon(
                              FluentIcons.dismiss_16_regular,
                              color: ColorPalette.SH_Grey900,
                              size: 14.sp,
                            ),
                        ],
                      ),
                      shape: StadiumBorder(
                          side: BorderSide(color: ColorPalette.SH_Grey100)),
                      selected: selected2.contains(categories[i]),
                      backgroundColor: ColorPalette.Primary_Color_Dark,
                      selectedColor: ColorPalette.SH_Grey100,
                      onSelected: (value) {
                        setStatecat(() {
                          if (!selected2.contains(categories[i])) {
                            selected2.add(categories[i]);
                          }
                          if (value == false) {
                            selected2.remove(categories[i]);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
