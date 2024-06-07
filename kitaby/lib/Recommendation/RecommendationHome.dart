// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Recommendation/recent.dart';
import 'package:kitaby/models/Recommendation/recommendation_response_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendationHome extends StatefulWidget {
  const RecommendationHome({super.key});
  @override
  State<RecommendationHome> createState() => RecommendationHomestate();
}

class RecommendationHomestate extends State<RecommendationHome> {
  List<Recent>? recent;
  List<Rec>? recbooks;
  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_recommendations_controller = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchRecentBooks();
    fetchRecommendations();
    _list_recommendations_controller.addListener(() {
      if (_list_recommendations_controller.position.maxScrollExtent ==
          _list_recommendations_controller.offset) {
        fetchRecommendations();
      }
    });
  }

  Future<void> fetchRecentBooks() async {
    try {
      RecentResponseModel response = await APISERVICES().getRecent();
      setState(() {
        recent = response.recent;
      });
    } catch (e) {
      print("Error fetching recent books: $e");
      setState(() {
        recent = [];
      });
    }
  }

  Future<void> fetchRecommendations() async {
    if (isloading) return;
    setState(() {
      isloading = true;
    });

    const limit = 8;
    try {
      RecommendationResponseModel response =
          await APISERVICES().getRecommendation(page);
      setState(() {
        page++;
        if ((response.rec?.length ?? 0) < limit) {
          hasmore = false;
        }
        recbooks = recbooks ?? [];
        recbooks!.addAll(response.rec ?? []);
        isloading = false;
      });
    } catch (e) {
      print("Error fetching recommendations: $e");
      setState(() {
        isloading = false;
      });
    }
  }

  Future<void> refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 1;
      recbooks = [];
    });
    await fetchRecommendations();
    await fetchRecentBooks();
  }

  Future<bool> setToken(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('token', value);
  }

  @override
  void dispose() {
    super.dispose();
    _list_recommendations_controller.dispose();
  }

  GlobalKey<ScaffoldState> ScaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      backgroundColor: ColorPalette.backgroundcolor,
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: RefreshIndicator(
          onRefresh: refresh,
          color: ColorPalette.Primary_Color_Light,
          child: ListView(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: -165,
                    left: -120,
                    child: FittedBox(
                      fit: BoxFit.none,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: ColorPalette.Primary_Color_Original),
                        height: 675,
                        width: 650,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        color: ColorPalette.Primary_Color_Original,
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                while (context.canPop()) {
                                  context.pop();
                                }
                                setToken("");
                                context.pushReplacementNamed(RoutesName.Login);
                              },
                              child: Icon(
                                FluentIcons.arrow_exit_20_filled,
                                color: ColorPalette.SH_Grey100,
                                size: 26.sp,
                              ),
                            ),
                            WidgetsModels.Container_widget(
                                null,
                                50,
                                Alignment.center,
                                null,
                                null,
                                Text(
                                  'Kitaby',
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey100,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 32),
                                )),
                            GestureDetector(
                              onTap: () {},
                              child: Icon(
                                FluentIcons.alert_32_regular,
                                color: ColorPalette.SH_Grey100,
                                size: 26.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      WidgetsModels.Container_widget(
                          null,
                          30,
                          Alignment.centerLeft,
                          const EdgeInsets.only(left: 30, top: 20, bottom: 20),
                          null,
                          Text(
                            'Recently Added',
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontWeight: FontWeight.w500,
                                fontSize: 24),
                          )),
                      Container(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: recent != null && recent!.isNotEmpty
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: recent!.length >= 3
                                    ? [
                                        GestureDetector(
                                          onTap: () {
                                            context.pushNamed(
                                                RoutesName.UserBook,
                                                pathParameters: {
                                                  "isbn": recent![0].isbn
                                                });
                                          },
                                          child: WidgetsModels.bookcard(
                                              recent![0].title,
                                              14,
                                              recent![0].author,
                                              10,
                                              ColorPalette.SH_Grey100,
                                              recent![0].image,
                                              110,
                                              null,
                                              110,
                                              170,
                                              false,
                                              null),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context.pushNamed(
                                                RoutesName.UserBook,
                                                pathParameters: {
                                                  "isbn": recent![1].isbn
                                                });
                                          },
                                          child: Container(
                                              margin: const EdgeInsets.only(
                                                  top: 50),
                                              child: WidgetsModels.bookcard(
                                                  recent![1].title,
                                                  16,
                                                  recent![1].author,
                                                  12,
                                                  ColorPalette.SH_Grey100,
                                                  recent![1].image,
                                                  130,
                                                  null,
                                                  125,
                                                  195,
                                                  false,
                                                  null)),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context.pushNamed(
                                                RoutesName.UserBook,
                                                pathParameters: {
                                                  "isbn": recent![2].isbn
                                                });
                                          },
                                          child: WidgetsModels.bookcard(
                                              recent![2].title,
                                              14,
                                              recent![2].author,
                                              10,
                                              ColorPalette.SH_Grey100,
                                              recent![2].image,
                                              110,
                                              null,
                                              110,
                                              170,
                                              false,
                                              null),
                                        ),
                                      ]
                                    : [],
                              )
                            : Center(
                                child: CircularProgressIndicator(
                                    color: ColorPalette.Primary_Color_Light)),
                      ),
                    ],
                  ),
                ],
              ),

              // Recommendations

              WidgetsModels.Container_widget(
                  null,
                  30,
                  Alignment.centerLeft,
                  const EdgeInsets.only(left: 30, top: 30, bottom: 10),
                  null,
                  Text(
                    'Recommendations',
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey100,
                        fontWeight: FontWeight.w500,
                        fontSize: 24),
                  )),

              SizedBox(
                height: 350,
                child: ListView.builder(
                  controller: _list_recommendations_controller,
                  padding: const EdgeInsets.all(12),
                  scrollDirection: Axis.horizontal,
                  itemCount: (recbooks?.length ?? 0) + 1,
                  itemBuilder: (context, i) {
                    if (i < (recbooks?.length ?? 0)) {
                      return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          child: GestureDetector(
                            onTap: () {
                              context.pushNamed(RoutesName.UserBook,
                                  pathParameters: {"isbn": recbooks![i].isbn});
                            },
                            child: WidgetsModels.bookcard(
                                recbooks![i].title,
                                14,
                                recbooks![i].author,
                                10,
                                ColorPalette.SH_Grey100,
                                recbooks![i].image,
                                115,
                                null,
                                115,
                                165,
                                false,
                                null),
                          ));
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                            child: Container(
                          margin: const EdgeInsets.only(bottom: 120).w,
                          child: hasmore
                              ? CircularProgressIndicator(
                                  color: ColorPalette.Primary_Color_Light,
                                )
                              : Text(
                                  'No More Books',
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.SH_Grey100,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                        )),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
