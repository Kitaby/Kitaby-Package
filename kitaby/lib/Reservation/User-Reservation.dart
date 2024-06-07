// ignore_for_file: camel_case_types, file_names, non_constant_identifier_names, avoid_print
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Filters/FilterBottomSheet.dart';
import 'package:kitaby/Reservation/Loanbottomsheet.dart';
import 'package:kitaby/models/Reservation/getLibsBooks_response_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';

class userreservation extends StatefulWidget {
  const userreservation({super.key});
  @override
  State<userreservation> createState() => userreservationstate();
}

class userreservationstate extends State<userreservation> {
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
    GetLibsBooksResponseModel response = await APISERVICES()
        .getLibsBooks(searched, SelectedCategories, SelectedWillays, page);

    ///get loan books
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
    fetchoffers("", SelectedCatego, SelectedWil);
  }

  @override
  void initState() {
    super.initState();
    fetchoffers("", SelectedCatego, SelectedWil);

    _list_offers_controller.addListener(() {
      if (_list_offers_controller.position.maxScrollExtent ==
          _list_offers_controller.offset) {
        fetchoffers(_searchcontroller.text, SelectedCatego, SelectedWil);
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
    history = (prefs.getStringList("historyres") != null)
        ? prefs.getStringList("historyres")!
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

  FocusNode focus = FocusNode();
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
            children: [
              Container(
                height: 100.h,
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
                            _searchcontroller, 275.w,
                            "Type : a title / an author",

                            //prefix
                            GestureDetector(
                                //set shared preferences
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  history = (sharedPreferences
                                              .getStringList("historyres") !=
                                          null)
                                      ? sharedPreferences
                                          .getStringList("historyres")!
                                      : [];
                                  if (!history.contains(
                                          _searchcontroller.value.text) &&
                                      _searchcontroller.value.text != "") {
                                    history.insert(
                                        0, _searchcontroller.value.text);
                                  }
                                  setState(() {
                                    sharedPreferences.setStringList(
                                        "historyres", history);
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: const Radius.circular(50.0).r),
                                      ),
                                      backgroundColor:
                                          ColorPalette.Primary_Color_Dark,
                                      context: context,
                                      builder: (context) => FilterBottomSheet(
                                            search: search,
                                            name: _searchcontroller.value.text,
                                          ));
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
                                          .getStringList("historyres") !=
                                      null)
                                  ? sharedPreferences
                                      .getStringList("historyres")!
                                  : [];
                              if (!history
                                      .contains(_searchcontroller.value.text) &&
                                  _searchcontroller.value.text != "") {
                                history.insert(0, _searchcontroller.value.text);
                              }
                              {
                                setState(() {
                                  sharedPreferences.setStringList(
                                      "historyres", history);
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
                          context.pushNamed(RoutesName.LoanNotif);
                        },
                        child: Icon(
                          FluentIcons.alert_badge_24_regular,
                          color: ColorPalette.SH_Grey100,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          focus.unfocus();
                          context.pushNamed(RoutesName.Loantimeline);
                        },
                        child: Icon(FluentIcons.clock_32_regular,
                            color: ColorPalette.SH_Grey100),
                      ),
                    ]),
              ),
              SizedBox(height: 20.h),
              if (searchfocus == false)
                StatefulBuilder(builder: (context, setStatelist) {
                  return RefreshIndicator(
                    onRefresh: refresh,
                    child: SizedBox(
                      height: MediaQuery.sizeOf(context).height - 250.h,
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: const Radius.circular(50.0).r),
                                      ),
                                      backgroundColor:
                                          ColorPalette.Primary_Color_Dark,
                                      context: context,
                                      builder: (context) => LoanBottomSheet(
                                        bookwanted: booksfound[2 * i],
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                      height: 350,
                                      width: 125,
                                      child: WidgetsModels.bookcard(
                                          booksfound[i * 2].title,
                                          14.sp,
                                          booksfound[i * 2].author,
                                          12.sp,
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: const Radius.circular(50.0).r),
                                      ),
                                      backgroundColor:
                                          ColorPalette.Primary_Color_Dark,
                                      context: context,
                                      builder: (context) => LoanBottomSheet(
                                        bookwanted: booksfound[2 * i + 1],
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                      height: 350,
                                      width: 125,
                                      child: WidgetsModels.bookcard(
                                          booksfound[i * 2 + 1].title,
                                          14.sp,
                                          booksfound[i * 2 + 1].author,
                                          12.sp,
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
                            190.w,
                            40.h,
                            Alignment.center,
                            null,
                            null,
                            Text(
                              'Recent Search',
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey100,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w500),
                            )),
                        WidgetsModels.Container_widget(
                            100.w,
                            40.h,
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
                      height: MediaQuery.sizeOf(context).height - 500.h,
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
                              height: 40.h,
                              margin: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10)
                                  .w,
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
                                        width: 250.w,
                                        child: Text(
                                          history[i],
                                          style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey100,
                                              fontSize: 16.sp,
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
                                                            "historyres") !=
                                                    null)
                                                ? sharedPreferences
                                                    .getStringList(
                                                        "historyres")!
                                                : [];
                                            if (sharedPreferences.getStringList(
                                                    "historyres") !=
                                                null) {
                                              history.removeAt(i);
                                            }
                                            setState(() {
                                              sharedPreferences.setStringList(
                                                  "historyres", history);
                                              print(sharedPreferences
                                                  .getStringList("historyres"));
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
