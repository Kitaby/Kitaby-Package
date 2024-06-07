// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names

import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/get_collection_responsemodel.dart';
import 'package:kitaby/profile/Addbook.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';

class mybooks extends StatefulWidget {
  const mybooks({super.key});
  @override
  State<mybooks> createState() => mybooksstate();
}

class mybooksstate extends State<mybooks> {
  List<BooksList> my_books = [];

  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_offers_controller = ScrollController();

  Future fetchoffers() async {
    if (isloading) return;
    isloading = true;
    Getcollectionresponsemodel? response =
        await APISERVICES().getCollection(page);
    setState(() {
      page++;
      isloading = false;
      if (response.booksList.length < 8) {
        hasmore = false;
      }
      my_books.addAll(response.booksList);
    });
  }

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 1;
      my_books.clear();
    });
    fetchoffers();
  }

  @override
  void initState() {
    super.initState();
    fetchoffers();

    _list_offers_controller.addListener(() {
      if (_list_offers_controller.position.maxScrollExtent ==
          _list_offers_controller.offset) {
        fetchoffers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _list_offers_controller.dispose();
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
          child: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "My Books",
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (context) => const Addbook(
                          addtype: "collection",
                        ),
                      ).whenComplete(() => refresh());

                      refresh();
                    },
                    child: Container(
                      margin: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Text(
                            "Add Book",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.Secondary_Color_Orignal,
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                          Icon(
                            FluentIcons.add_16_regular,
                            color: ColorPalette.Secondary_Color_Orignal,
                            size: 22,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 700,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _list_offers_controller,
                    itemCount: (my_books.length % 2 == 0)
                        ? (my_books.length / 2 + 1).ceil()
                        : ((my_books.length + 1) / 2).ceil(),
                    itemBuilder: (context, i) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (i * 2 < my_books.length)
                            SizedBox(
                                height: 300,
                                width: 125,
                                child: WidgetsModels.bookcard(
                                    my_books[i * 2].title,
                                    14,
                                    my_books[i * 2].author,
                                    12,
                                    ColorPalette.SH_Grey100,
                                    my_books[i * 2].image,
                                    115,
                                    null,
                                    115,
                                    180,
                                    false,
                                    "mybooks")),
                          if (i * 2 + 1 < my_books.length)
                            SizedBox(
                                height: 300,
                                width: 125,
                                child: WidgetsModels.bookcard(
                                    my_books[i * 2 + 1].title,
                                    14,
                                    my_books[i * 2 + 1].author,
                                    12,
                                    ColorPalette.SH_Grey100,
                                    my_books[i * 2 + 1].image,
                                    115,
                                    null,
                                    115,
                                    180,
                                    false,
                                    "mybooks")),
                          if (i * 2 + 2 == my_books.length + 1)
                            Center(
                                child: hasmore
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'No More Books',
                                        style: GoogleFonts.montserrat(
                                            color: ColorPalette.SH_Grey100,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
