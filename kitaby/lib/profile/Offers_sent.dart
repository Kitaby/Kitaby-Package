// ignore_for_file: non_constant_identifier_names, camel_case_types, file_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/get_sentoffersmodel.dart';

class offerssent extends StatefulWidget {
  const offerssent({super.key});
  @override
  State<offerssent> createState() => offerssentstate();
}

class offerssentstate extends State<offerssent> {
  List<OfferElement> offerslist = [];

  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_offers_controller = ScrollController();

  Future fetchoffers() async {
    if (isloading) return;
    isloading = true;
    GetsentoffersResponseModel? response =
        await APISERVICES().getsentoffers(page);
    if (response != null) {
      setState(() {
        page++;
        isloading = false;
        if (response.offers.length < 8) {
          hasmore = false;
        }
        offerslist.addAll(response.offers);
      });
    }
  }

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 1;
      offerslist.clear();
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
          child: SizedBox(
            height: 750,
            child: RefreshIndicator(
              onRefresh: refresh,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                controller: _list_offers_controller,
                itemCount: offerslist.length + 1,
                itemBuilder: (context, i) {
                  if (i < offerslist.length) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 300,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  WidgetsModels.bookcard(
                                      offerslist[i].demandedBook.title,
                                      12,
                                      offerslist[i].demandedBook.author,
                                      10,
                                      ColorPalette.SH_Grey100,
                                      offerslist[i].demandedBook.image,
                                      100,
                                      180,
                                      60,
                                      90,
                                      false,
                                      null),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        left: 15, right: 15, bottom: 50),
                                    height: 125,
                                    width: 280,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To ${offerslist[i].owner.name}",
                                          style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey100,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Text(
                                            " ”${offerslist[i].owner.name}” hasn’t decided yet to accept or refuse your offer please wait !",
                                            textAlign: TextAlign.center,
                                            maxLines: 3,
                                            style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey100,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: 80,
                                            ),
                                            GestureDetector(
                                                onTap: () async {
                                                  await APISERVICES()
                                                      .canceloffer(offerslist[i]
                                                          .offer
                                                          .id);
                                                  refresh();
                                                },
                                                child: WidgetsModels.button1(
                                                    80,
                                                    20,
                                                    ColorPalette.Error,
                                                    FluentIcons
                                                        .calendar_cancel_20_filled,
                                                    ColorPalette.SH_Grey100,
                                                    "Cancel Offer")),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 100),
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
                                  'No More offers',
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
          ),
        ));
  }
}
