// ignore_for_file: file_names, library_private_types_in_public_api

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';

class WillayaBottomSheet extends StatefulWidget {
  final List<String> oldwillayas;

  const WillayaBottomSheet({super.key, required this.oldwillayas});
  @override
  _WillayaBottomSheetState createState() => _WillayaBottomSheetState();
}

class _WillayaBottomSheetState extends State<WillayaBottomSheet> {
  List<String> willayas = [
    "Adrar",
    "Chlef",
    "Laghouat",
    "Oum El Bouaghi",
    "Batna",
    "Béjaïa",
    "Biskra",
    "Béchar",
    "Blida",
    "Bouira",
    "Tamanrasset",
    "Tébessa",
    "Tlemcen",
    "Tiaret",
    "Tizi Ouzou",
    "Alger",
    "Djelfa",
    "Jijel",
    "Sétif",
    "Saïda",
    "Skikda",
    "Sidi Bel Abbès",
    "Annaba",
    "Guelma",
    "Constantine",
    "Médéa",
    "Mostaganem",
    "M'Sila",
    "Mascara",
    "Ouargla",
    "Oran",
    "El Bayadh",
    "Illizi",
    "Bordj Bou Arréridj",
    "Boumerdès",
    "El Tarf",
    "Tindouf",
    "Tissemsilt",
    "El Oued",
    "Khenchela",
    "Souk Ahras",
    "Tipaza",
    "Mila",
    "Aïn Defla",
    "Naâma",
    "Aïn Témouchent",
    "Ghardaïa",
    "Relizane",
    "El M'ghair",
    "El Menia",
    "Ouled Djellal",
    "Bordj Baji Mokhtar",
    "Béni Abbès",
    "Timimoun",
    "Touggourt",
    "Djanet",
    "In Salah"
  ];

  List<String> selected = [];

  @override
  void initState() {
    super.initState();
    selected = widget.oldwillayas;
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
                      'Willaya',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600),
                    )),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, selected);
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
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: willayas.length,
              itemBuilder: (context, i) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return ChoiceChip(
                      label: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (!selected.contains(willayas[i]))
                            Icon(
                              FluentIcons.add_16_regular,
                              color: ColorPalette.Secondary_Color_Orignal,
                              size: 18.sp,
                            ),
                          Text(
                            willayas[i],
                            style: GoogleFonts.montserrat(
                                color: (selected.contains(willayas[i]))
                                    ? ColorPalette.SH_Grey900
                                    : ColorPalette.SH_Grey100,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600),
                          ),
                          if (selected.contains(willayas[i]))
                            Icon(
                              FluentIcons.dismiss_16_regular,
                              color: ColorPalette.SH_Grey900,
                              size: 14.sp,
                            ),
                        ],
                      ),
                      shape: StadiumBorder(
                          side: BorderSide(color: ColorPalette.SH_Grey100)),
                      selected: (selected.contains(willayas[i])),
                      backgroundColor: ColorPalette.Primary_Color_Dark,
                      selectedColor: ColorPalette.SH_Grey100,
                      onSelected: (value) {
                        setState(() {
                          if (!selected.contains(willayas[i])) {
                            selected.add(willayas[i]);
                          }
                          if (value == false) {
                            selected.remove(willayas[i]);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
