// ignore_for_file: file_names
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/config.dart';
import 'package:kitaby/models/profile/get_profile_response_model.dart';
import 'package:kitaby/profile/LoanBooks.dart';
import 'package:kitaby/profile/My_books.dart';
import 'package:kitaby/profile/Offers_sent.dart';
import 'package:kitaby/profile/Receive_Exchange_Offer.dart';
import 'package:kitaby/profile/Wishlist.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});
  @override
  State<Profile> createState() => Profilestate();
}

class Profilestate extends State<Profile> {
  bool isloading = false;
  late Info profileInfo;
  List<bool> selected = [true, false, false, false, false];
  Future fetchProfile() async {
    if (isloading) return;
    isloading = true;
    APISERVICES().getProfile().then((response) => {
          if (response.message == "success")
            {
              setState(() {
                profileInfo = response.info;
                isloading = false;
              }),
            }
        });
  }

  @override
  void initState() {
    fetchProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: isloading
            ? Center(
                child: CircularProgressIndicator(
                  color: ColorPalette.Primary_Color_Light,
                ),
              )
            : ListView(
                children: [
                  WidgetsModels.Container_widget(
                    null,
                    60.h,
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
                  ),
                  SizedBox(
                    height: 780.h,
                    child: ListView(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width / 4,
                              height: MediaQuery.sizeOf(context).width / 4,
                              alignment: Alignment.center,
                              margin:
                                  const EdgeInsets.only(top: 30, bottom: 20).w,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "${config.http}/${profileInfo.photo}"),
                                    fit: BoxFit.cover,
                                  )),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5).w,
                          child: Center(
                            child: Text(
                              profileInfo.name,
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey100,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5).w,
                          child: Center(
                            child: Text(
                              "reader",
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey300,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 5).w,
                          child: Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10).w,
                                child: Icon(
                                  FluentIcons.location_12_filled,
                                  color: ColorPalette.SH_Grey300,
                                ),
                              ),
                              Text(
                                profileInfo.wilaya,
                                style: GoogleFonts.montserrat(
                                    color: ColorPalette.SH_Grey300,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          )),
                        ),
                        Container(
                            margin: const EdgeInsets.symmetric(vertical: 5).w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "${profileInfo.books}",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Books",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey300,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "${profileInfo.exchanges}",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Exchanges",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey300,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "4.8",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "Rating",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey300,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        GestureDetector(
                            onTap: () {
                              context.pushNamed(RoutesName.EditProfile,
                                  pathParameters: {
                                    "image":
                                        "${config.http}/${profileInfo.photo}",
                                    "wilaya": profileInfo.wilaya
                                  });
                            },
                            child: WidgetsModels.Container_widget(
                              null,
                              35.h,
                              Alignment.center,
                              const EdgeInsets.only(
                                      left: 125,
                                      right: 125,
                                      top: 20,
                                      bottom: 30)
                                  .w,
                              BoxDecoration(
                                color: ColorPalette.SH_Grey100,
                                borderRadius: BorderRadius.circular(5).r,
                              ),
                              Text(
                                'Edit Profile',
                                style: GoogleFonts.montserrat(
                                    color: ColorPalette.SH_Grey900,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            )),
                        SizedBox(
                          height: 50.h,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        (selected[0])
                                            ? FluentIcons.book_24_filled
                                            : FluentIcons.book_24_regular,
                                        size: 28.sp,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                      onTap: () {
                                        selected.setAll(0, [
                                          false,
                                          false,
                                          false,
                                          false,
                                          false
                                        ]);
                                        setState(() {
                                          selected[0] = true;
                                        });
                                      },
                                    ),
                                    if (selected[0])
                                      Container(
                                          height: 2.h,
                                          color: ColorPalette.SH_Grey100),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        (selected[1])
                                            ? FluentIcons.book_clock_24_filled
                                            : FluentIcons.book_clock_24_regular,
                                        size: 28,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                      onTap: () {
                                        selected.setAll(0, [
                                          false,
                                          false,
                                          false,
                                          false,
                                          false
                                        ]);
                                        setState(() {
                                          selected[1] = true;
                                        });
                                      },
                                    ),
                                    if (selected[1])
                                      Container(
                                          height: 2.h,
                                          color: ColorPalette.SH_Grey100),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        (selected[2])
                                            ? FluentIcons.bookmark_24_filled
                                            : FluentIcons.bookmark_24_regular,
                                        size: 28.sp,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                      onTap: () {
                                        selected.setAll(0, [
                                          false,
                                          false,
                                          false,
                                          false,
                                          false
                                        ]);
                                        setState(() {
                                          selected[2] = true;
                                        });
                                      },
                                    ),
                                    if (selected[2])
                                      Container(
                                          height: 2.h,
                                          color: ColorPalette.SH_Grey100),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        (selected[3])
                                            ? FluentIcons
                                                .person_arrow_right_24_filled
                                            : FluentIcons
                                                .person_arrow_right_24_regular,
                                        size: 28.sp,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                      onTap: () {
                                        selected.setAll(0, [
                                          false,
                                          false,
                                          false,
                                          false,
                                          false
                                        ]);
                                        setState(() {
                                          selected[3] = true;
                                        });
                                      },
                                    ),
                                    if (selected[3])
                                      Container(
                                          height: 2.h,
                                          color: ColorPalette.SH_Grey100),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      child: Icon(
                                        (selected[4])
                                            ? FluentIcons
                                                .person_arrow_left_24_filled
                                            : FluentIcons
                                                .person_arrow_left_24_regular,
                                        size: 28.sp,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                      onTap: () {
                                        selected.setAll(0, [
                                          false,
                                          false,
                                          false,
                                          false,
                                          false
                                        ]);
                                        setState(() {
                                          selected[4] = true;
                                        });
                                      },
                                    ),
                                    if (selected[4])
                                      Container(
                                          height: 2.h,
                                          color: ColorPalette.SH_Grey100),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (selected[0])
                          SizedBox(height: 400.h, child: const mybooks()),
                        if (selected[1])
                          SizedBox(height: 400.h, child: const LoanBooks()),
                        if (selected[2])
                          SizedBox(height: 400.h, child: const wishlist()),
                        if (selected[3])
                          Container(
                            margin: const EdgeInsets.all(20).w,
                            child: Text(
                              "Offers Sent",
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey100,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        if (selected[3])
                          SizedBox(height: 300.h, child: const offerssent()),
                        if (selected[4])
                          Container(
                            margin: const EdgeInsets.all(20).w,
                            child: Text(
                              "Offers Received",
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey100,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        if (selected[4])
                          SizedBox(height: 300.h, child: const receiveoffer()),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
