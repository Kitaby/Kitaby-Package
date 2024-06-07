// ignore_for_file: avoid_print, camel_case_types, non_constant_identifier_names

import 'dart:math';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Filters/FilterBottomSheet.dart';
import 'package:kitaby/Exchange/OfferBottomSheet.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/getBooksresponsemodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';

class userexchange extends StatefulWidget {
  const userexchange({super.key});
  @override
  State<userexchange> createState() => userexchangestate();
}

class userexchangestate extends State<userexchange> {
  List<AllBook> booksfound = [];
  List<String> SelectedCatego = [];
  List<String> SelectedWil = [];
  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_offers_controller = ScrollController();

  Future fetchoffers(String searched, List<String> SelectedCategories,
      List<String> SelectedWillays) async {
    if (isloading) return;
    isloading = true;
    GetBooksresponsemodel? response = await APISERVICES().getBooks(
        searched, SelectedCategories, SelectedWillays, page); //////////////

    ///get exchange books

    setState(() {
      page++;
      isloading = false;
      if (response.allBooks.length < 8) {
        hasmore = false;
      }
      booksfound.addAll(response.allBooks);
    });
  }

  Future refresh() async {
    setState(() {
      seeall = false;
      isloading = false;
      hasmore = true;
      page = 1;
      booksfound.clear();
      _searchcontroller.text = "";
    });
    fetchoffers("", SelectedCatego, SelectedWil); ////////////
  }

  @override
  void initState() {
    super.initState();
    fetchoffers("", SelectedCatego, SelectedWil); //////////

    _list_offers_controller.addListener(() {
      if (_list_offers_controller.position.maxScrollExtent ==
          _list_offers_controller.offset) {
        print(page);
        fetchoffers(
            _searchcontroller.text, SelectedCatego, SelectedWil); ///////
      }
    });

    getSharedPrefs2();
  }

  @override
  void dispose() {
    super.dispose();
    _list_offers_controller.dispose();
  }

  List<String> history = [];
  Future getSharedPrefs2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    history = (prefs.getStringList("historyex") != null)
        ? prefs.getStringList("historyex")!
        : [];
  }

  void search(
      String e, List<String> SelectedCategories, List<String> SelectedWillaya) {
    setState(() {
      if (SelectedCategories != SelectedCatego) {
        SelectedCatego.clear();
        SelectedCatego.addAll(SelectedCategories);
      }
      if (SelectedWillaya != SelectedWil) {
        SelectedWil.clear();
        SelectedWil.addAll(SelectedWillaya);
      }
      isloading = false;
      hasmore = true;
      page = 1;
      booksfound.clear();
      seeall = false;
      fetchoffers(e, SelectedCategories, SelectedWillaya);
    });
  }

  static FocusNode focus = FocusNode();
  final _searchcontroller = TextEditingController();
  bool searchfocus = false;
  bool seeall = false;

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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Container(
                height: 100,
                color: ColorPalette.Primary_Color_Original,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Focus(
                          focusNode: focus,
                          onFocusChange: (value) {
                            setState(() {
                              searchfocus = !searchfocus;
                            });
                          },
                          child: WidgetsModels.searchbar(
                            _searchcontroller, 275,
                            "Type : a title / an author",

                            //prefix
                            GestureDetector(
                                //set shared preferences
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  history = (sharedPreferences
                                              .getStringList("historyex") !=
                                          null)
                                      ? sharedPreferences
                                          .getStringList("historyex")!
                                      : [];
                                  if (!history.contains(
                                          _searchcontroller.value.text) &&
                                      _searchcontroller.value.text != "") {
                                    history.insert(
                                        0, _searchcontroller.value.text);
                                  }
                                  setState(() {
                                    sharedPreferences.setStringList(
                                        "historyex", history);

                                    if (focus.hasFocus) {
                                      focus.unfocus();
                                    } else {
                                      FocusScope.of(context)
                                          .requestFocus(focus);
                                    }
                                    print(SelectedWil);
                                    search(_searchcontroller.value.text,
                                        SelectedCatego, SelectedWil);
                                  });
                                },
                                child: Icon(
                                  FluentIcons.search_20_regular,
                                  color: ColorPalette.SH_Grey900,
                                )),
                            //suffix
                            GestureDetector(
                                onTap: () {
                                  showModalBottomSheet<dynamic>(
                                    isScrollControlled: true,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(50.0)),
                                    ),
                                    backgroundColor:
                                        ColorPalette.Primary_Color_Dark,
                                    context: context,
                                    builder: (context) => FilterBottomSheet(
                                        name: _searchcontroller.value.text,
                                        search: search),
                                  );
                                },
                                child: Icon(
                                  FluentIcons.pin_20_regular,
                                  color: ColorPalette.SH_Grey900,
                                )),

                            //onchanged
                            (p0) => (),
                            //onsubmitted
                            (p0) async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              history = (sharedPreferences
                                          .getStringList("historyex") !=
                                      null)
                                  ? sharedPreferences
                                      .getStringList("historyex")!
                                  : [];
                              if (!history
                                      .contains(_searchcontroller.value.text) &&
                                  _searchcontroller.value.text != "") {
                                history.insert(0, _searchcontroller.value.text);
                              }
                              {
                                setState(() {
                                  sharedPreferences.setStringList(
                                      "historyex", history);
                                  focus.unfocus();
                                  print(SelectedWil);
                                  search(_searchcontroller.value.text,
                                      SelectedCatego, SelectedWil);
                                });
                              }
                            },
                          )),
                      GestureDetector(
                        onTap: () {
                          focus.unfocus();
                          context.pushNamed(RoutesName.ExchangeNotif);
                        },
                        child: Icon(
                          FluentIcons.alert_badge_24_regular,
                          color: ColorPalette.SH_Grey100,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          focus.unfocus();
                          context.pushNamed(RoutesName.userMessages);
                        },
                        child: Icon(FluentIcons.send_32_regular,
                            color: ColorPalette.SH_Grey100),
                      ),
                    ]),
              ),
              const SizedBox(height: 20),
              if (searchfocus == false)
                StatefulBuilder(builder: (context, setStatelist) {
                  return RefreshIndicator(
                    onRefresh: refresh,
                    backgroundColor: ColorPalette.SH_Grey100,
                    color: ColorPalette.Primary_Color_Light,
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height - 250,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: _list_offers_controller,
                        scrollDirection: Axis.vertical,
                        itemCount: (booksfound.length / 2).ceil() + 1,
                        itemBuilder: (context, i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (i * 2 < booksfound.length)
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<dynamic>(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(50.0)),
                                      ),
                                      backgroundColor:
                                          ColorPalette.Primary_Color_Dark,
                                      context: context,
                                      builder: (context) => OfferBottomSheet(
                                        bookwanted: booksfound[i * 2],
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                      height: 300,
                                      width: 125,
                                      child: WidgetsModels.bookcard(
                                          booksfound[i * 2].title,
                                          14,
                                          booksfound[i * 2].author,
                                          12,
                                          ColorPalette.SH_Grey100,
                                          booksfound[i * 2].image,
                                          115,
                                          null,
                                          115,
                                          180,
                                          false,
                                          null)),
                                ),
                              if (i * 2 + 1 < booksfound.length)
                                GestureDetector(
                                  onTap: () {
                                    showModalBottomSheet<dynamic>(
                                      isScrollControlled: true,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(50.0)),
                                      ),
                                      backgroundColor:
                                          ColorPalette.Primary_Color_Dark,
                                      context: context,
                                      builder: (context) => OfferBottomSheet(
                                        bookwanted: booksfound[i * 2 + 1],
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                      height: 300,
                                      width: 125,
                                      child: WidgetsModels.bookcard(
                                          booksfound[i * 2 + 1].title,
                                          14,
                                          booksfound[i * 2 + 1].author,
                                          12,
                                          ColorPalette.SH_Grey100,
                                          booksfound[i * 2 + 1].image,
                                          115,
                                          null,
                                          115,
                                          180,
                                          false,
                                          null)),
                                ),
                              if (i * 2 + 1 == booksfound.length + 1)
                                Center(
                                    child: isloading
                                        ? CircularProgressIndicator(
                                            color: ColorPalette
                                                .Primary_Color_Light,
                                          )
                                        : Center(
                                            child: Text(
                                              'No More Books',
                                              style: GoogleFonts.montserrat(
                                                  color:
                                                      ColorPalette.SH_Grey100,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                })
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        WidgetsModels.Container_widget(
                            190,
                            40,
                            Alignment.center,
                            null,
                            null,
                            Text(
                              'Recent Search',
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey100,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            )),
                        WidgetsModels.Container_widget(
                            100,
                            40,
                            Alignment.center,
                            null,
                            null,
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  seeall = !seeall;
                                });
                              },
                              child: Text(
                                'See All',
                                style: GoogleFonts.montserrat(
                                    color: (!seeall)
                                        ? ColorPalette.Secondary_Color_Light
                                        : ColorPalette.SH_Grey300,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500),
                              ),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height - 500,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount:
                            (seeall) ? history.length : min(history.length, 6),
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _searchcontroller.text = history[i];
                                search(_searchcontroller.value.text,
                                    SelectedCatego, SelectedWil);
                                focus.unfocus();
                              });
                            },
                            child: Container(
                              height: 40,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(
                                        FluentIcons.clock_24_regular,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                      SizedBox(
                                        width: 250,
                                        child: Text(
                                          history[i],
                                          style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey100,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      GestureDetector(
                                          onTap: () async {
                                            SharedPreferences
                                                sharedPreferences =
                                                await SharedPreferences
                                                    .getInstance();
                                            history = (sharedPreferences
                                                        .getStringList(
                                                            "historyex") !=
                                                    null)
                                                ? sharedPreferences
                                                    .getStringList("historyex")!
                                                : [];
                                            if (sharedPreferences.getStringList(
                                                    "historyex") !=
                                                null) {
                                              history.removeAt(i);
                                            }
                                            setState(() {
                                              sharedPreferences.setStringList(
                                                  "historyex", history);
                                              print(sharedPreferences
                                                  .getStringList("historyex"));
                                            });
                                          },
                                          child: Icon(
                                            FluentIcons.dismiss_24_regular,
                                            color: ColorPalette.SH_Grey100,
                                          ))
                                    ],
                                  ),
                                  Container(
                                    color: ColorPalette.SH_Grey100,
                                    height: 1,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
            ],
          ),
        ));
  }
}
