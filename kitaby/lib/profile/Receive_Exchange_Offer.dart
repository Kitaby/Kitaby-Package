// ignore_for_file: file_names, camel_case_types, non_constant_identifier_names
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/get_received_offer_responsemodel.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';

class receiveoffer extends StatefulWidget {
  const receiveoffer({super.key});
  @override
  State<receiveoffer> createState() => receiveofferstate();
}

class receiveofferstate extends State<receiveoffer> {
  List<OfferElement> offers = [];
  List<int> selectedIndex = [];
  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_offers_controller = ScrollController();

  Future fetchoffers() async {
    if (isloading) return;
    isloading = true;
    ReceivedOffersResponseModel? response =
        await APISERVICES().getreceivedoffers(page);
    if (response != null) {
      setState(() {
        page++;
        isloading = false;
        if (response.offers.length < 8) {
          hasmore = false;
        }
        offers.addAll(response.offers);
        selectedIndex.addAll(List.generate(response.offers.length, (index) {
          return 0;
        }));
      });
    }
  }

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 1;
      offers.clear();
      selectedIndex.clear();
    });
    fetchoffers();
  }

  @override
  void initState() {
    super.initState();

    selectedIndex.clear;
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
          child: RefreshIndicator(
            onRefresh: refresh,
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _list_offers_controller,
              scrollDirection: Axis.vertical,
              itemCount: offers.length + 1,
              itemBuilder: (context, index) {
                if (index < offers.length) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 400,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  'Your book',
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey100,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 70,
                                ),
                                Text(
                                  '${(offers[index].buyer.length > 16) ? ("${offers[index].buyer.substring(0, 15)}...") : offers[index].buyer}\'s Books',
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey100,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                ),
                                WidgetsModels.bookcard(
                                    offers[index].demandedBook.title,
                                    12,
                                    offers[index].demandedBook.author,
                                    10,
                                    ColorPalette.SH_Grey100,
                                    offers[index].demandedBook.image,
                                    70,
                                    180,
                                    70,
                                    90,
                                    false,
                                    "mybooks"),
                                const SizedBox(
                                  width: 30,
                                ),
                                SizedBox(
                                  height: 165,
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 5),
                                        child: Text(
                                          'Accept',
                                          style: GoogleFonts.montserrat(
                                              color: ColorPalette
                                                  .Secondary_Color_Light,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await APISERVICES().acceptoffer(
                                              offers[index].offer.id,
                                              offers[index]
                                                  .proposedBooks[
                                                      selectedIndex[index]]
                                                  .isbn);
                                          refresh();
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            decoration: BoxDecoration(
                                                color: ColorPalette
                                                    .Secondary_Color_Light,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            child: Icon(
                                              FluentIcons
                                                  .arrows_bidirectional_24_filled,
                                              color:
                                                  ColorPalette.backgroundcolor,
                                              size: 30,
                                            )),
                                      ),
                                      Text(
                                        'Deny',
                                        style: GoogleFonts.montserrat(
                                            color: ColorPalette.Error,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      GestureDetector(
                                        onTap: () async {
                                          await APISERVICES().rejectoffer(
                                              offers[index].offer.id);

                                          refresh();
                                        },
                                        child: Container(
                                            decoration: BoxDecoration(
                                                color: ColorPalette.Error,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            child: Icon(
                                              FluentIcons.dismiss_24_filled,
                                              color:
                                                  ColorPalette.backgroundcolor,
                                              size: 30,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                StatefulBuilder(
                                    builder: (context, setstateselect) {
                                  return Expanded(
                                    child: SizedBox(
                                      height: 165,
                                      child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: offers[index]
                                              .proposedBooks
                                              .length,
                                          itemBuilder: (context, j) {
                                            return Stack(
                                              children: [
                                                SizedBox(
                                                    width: 100,
                                                    child: GestureDetector(
                                                        onTap: () {
                                                          setstateselect(() {
                                                            selectedIndex[
                                                                index] = j;
                                                          });
                                                        },
                                                        child: WidgetsModels.bookcard(
                                                            offers[index]
                                                                .proposedBooks[
                                                                    j]
                                                                .title,
                                                            12,
                                                            offers[index]
                                                                .proposedBooks[
                                                                    j]
                                                                .author,
                                                            10,
                                                            ColorPalette
                                                                .SH_Grey100,
                                                            offers[index]
                                                                .proposedBooks[
                                                                    j]
                                                                .image,
                                                            70,
                                                            165,
                                                            70,
                                                            90,
                                                            (selectedIndex[
                                                                    index] ==
                                                                j),
                                                            null))),
                                                Positioned(
                                                  bottom: 0,
                                                  left: 0,
                                                  child: Radio(
                                                    fillColor: MaterialStateColor
                                                        .resolveWith((states) =>
                                                            Colors.transparent),
                                                    overlayColor:
                                                        const MaterialStatePropertyAll(
                                                            Colors.transparent),
                                                    value: j,
                                                    groupValue: selectedIndex,
                                                    onChanged:
                                                        (value) {}, //vide
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  );
                                }),
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 170),
                              color: ColorPalette.SH_Grey100,
                              height: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                        child: hasmore
                            ? CircularProgressIndicator(
                                color: ColorPalette.Primary_Color_Light,
                              )
                            : Text(
                                'No More Offers',
                                style: GoogleFonts.montserrat(
                                    color: ColorPalette.SH_Grey100,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              )),
                  );
                }
              },
            ),
          ),
        ));
  }
}
