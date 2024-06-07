import 'dart:convert';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Path.dart';

class LoanNotif extends StatefulWidget {
  const LoanNotif({super.key});

  @override
  State<LoanNotif> createState() => _LoanNotifState();
}

class _LoanNotifState extends State<LoanNotif> {
  static String user = "user";

  List notificationsLoan = [
    {'typeNotif': "3days"},
    {'typeNotif': "taken"},
    {'typeNotif': "canceled"},
    {'typeNotif': "3days"},
    {'typeNotif': "3days"},
    {'typeNotif': "taken"},
    {'typeNotif': "taken"},
    {'typeNotif': "canceled"},
  ];

  Future<List> getData() async {
    var response =
        await get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    List responsebody = jsonDecode(response.body);
    return responsebody;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: ColorPalette.backgroundcolor,
          child: Column(
            children: [
              WidgetsModels.title(context),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: FutureBuilder<List>(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: Image.asset(Path.LogoImg),
                        );
                      }
                      return ListView.builder(
                        itemCount: notificationsLoan.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 100),
                                      child: WidgetsModels.bookcard(
                                          "title",
                                          10,
                                          "author",
                                          8,
                                          ColorPalette.SH_Grey100,
                                          "https://edit.org/images/cat/book-covers-big-2019101610.jpg",
                                          64,
                                          250,
                                          150,
                                          95,
                                          false,
                                          ""),
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        child: Column(
                                          children: [
                                            WidgetsModels.Container_widget(
                                              104,
                                              30,
                                              Alignment.topCenter,
                                              const EdgeInsets.only(bottom: 10),
                                              null,
                                              Text(
                                                "User's name ",
                                                style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            if (notificationsLoan[index]
                                                    ['typeNotif'] ==
                                                "3days")
                                              WidgetsModels.Container_widget(
                                                300,
                                                75,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15, right: 30),
                                                null,
                                                Text(
                                                  "Hello dear $user ,you need to go and take your book from the Library before 3 days or your request will be canceled, thanks for your understanding !",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              )
                                            else if (notificationsLoan[index]
                                                    ['typeNotif'] ==
                                                "taken")
                                              WidgetsModels.Container_widget(
                                                300,
                                                75,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15, right: 30),
                                                null,
                                                Text(
                                                  "Hello dear $user ,Thanks for coming now your loan period has started you need to return the book after 10 days enjoy it !",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              )
                                            else
                                              WidgetsModels.Container_widget(
                                                300,
                                                75,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15, right: 30),
                                                null,
                                                Text(
                                                  "Hello dear $user , Sadly you didn’t came to take your book from us, We inform you that your loan request has been canceled retry later thanks !",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: WidgetsModels.button1(
                                                    90,
                                                    21,
                                                    ColorPalette.Error,
                                                    FluentIcons
                                                        .delete_16_filled,
                                                    ColorPalette.SH_Grey100,
                                                    "Delete Notifi")),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              WidgetsModels.Container_widget(
                                  null,
                                  1,
                                  null,
                                  const EdgeInsets.symmetric(vertical: 20),
                                  BoxDecoration(color: ColorPalette.SH_Grey100),
                                  null),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
