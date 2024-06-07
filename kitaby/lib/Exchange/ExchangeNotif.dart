import 'dart:convert';
import 'package:kitaby/Constants/Path.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';

class ExchangeNotif extends StatefulWidget {
  const ExchangeNotif({super.key});

  @override
  State<ExchangeNotif> createState() => _ExchangeNotifState();
}

class _ExchangeNotifState extends State<ExchangeNotif> {
  static String user = "user";
  static String userName = ' "Users name" ';
  static String bookName = ' "Boooks name" ';

  List notificationsExch = [
    {'typeNotif': "offer"},
    {'typeNotif': "accepted"},
    {'typeNotif': "refused"},
    {'typeNotif': "offer"},
    {'typeNotif': "offer"},
    {'typeNotif': "acceped"},
    {'typeNotif': "accepted"},
    {'typeNotif': "refused"},
  ];

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
                        itemCount: notificationsExch.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 25),
                                child: Row(
                                  children: [
                                    WidgetsModels.bookcard(
                                        "vartitle",
                                        12,
                                        "varauthor",
                                        10,
                                        ColorPalette.SH_Grey100,
                                        "https://edit.org/images/cat/book-covers-big-2019101610.jpg",
                                        64,
                                        120,
                                        91,
                                        80,
                                        false,
                                        ""),
                                    if (notificationsExch[index]['typeNotif'] ==
                                        "offer")
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            children: [
                                              WidgetsModels.Container_widget(
                                                104,
                                                20,
                                                Alignment.topCenter,
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                                null,
                                                Text(
                                                  "User's name ",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              WidgetsModels.Container_widget(
                                                300,
                                                70,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15, right: 30),
                                                null,
                                                Text(
                                                  "Hello dear $user , $userName sent you an exchange offer with his book $bookName, Please answer to him thanks for understanding !",
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
                                                      "Delete Notif")),
                                            ],
                                          ),
                                        ),
                                      )
                                    else if (notificationsExch[index]
                                            ['typeNotif'] ==
                                        "accepted")
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            children: [
                                              WidgetsModels.Container_widget(
                                                104,
                                                20,
                                                Alignment.topCenter,
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                                null,
                                                Text(
                                                  "User's name ",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              WidgetsModels.Container_widget(
                                                300,
                                                70,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15, right: 30),
                                                null,
                                                Text(
                                                  "Hello dear $user , your exchange request for this book was accepted by $userName you can now talk with him about the exchange steps be free !",
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
                                                      "Delete Notif")),
                                            ],
                                          ),
                                        ),
                                      )
                                    else
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            children: [
                                              WidgetsModels.Container_widget(
                                                104,
                                                20,
                                                Alignment.topCenter,
                                                const EdgeInsets.only(
                                                    bottom: 10),
                                                null,
                                                Text(
                                                  "User's name ",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              WidgetsModels.Container_widget(
                                                300,
                                                70,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15, right: 30),
                                                null,
                                                Text(
                                                  "Hello dear $user , Sadly your exchange request for this book was refused by $userName Please try to find another user to deal with , thanks for understanding !",
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
                                                      "Delete Notif")),
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
