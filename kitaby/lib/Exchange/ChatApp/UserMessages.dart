// ignore_for_file: prefer_const_constructors, file_names, non_constant_identifier_names
import 'dart:math';
import 'package:kitaby/models/config.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Exchnage/Chat/get_user_chats_response_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserMessages extends StatefulWidget {
  const UserMessages({super.key});

  @override
  State<UserMessages> createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> {
  String? token;
  Future<void> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  void change(String str) {}
  void send(String str) {}
  final _searchMessController = TextEditingController();
  List<Chat> messages = [];
  bool hasmore = true;
  int page = 0;
  bool isloading = false;
  final _list_recomondations_controller = ScrollController();
  FocusNode focus = FocusNode();
  final _searchcontroller = TextEditingController();
  bool searchfocus = false;
  bool seeall = false;
  Future fetchChats(String name) async {
    if (isloading) return;
    isloading = true;
    await APISERVICES().getUserChat(name).then(
          (response) => {
            setState(() {
              print(response.chats);
              isloading = false;
              hasmore = false;
              messages.addAll(response.chats);
            })
          },
        );
  }

  void search(String e) {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 0;
      messages.clear();
      seeall = false;
      fetchChats(e);
    });
  }

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 0;
      messages.clear();
    });
    fetchChats("");
  }

  List<String> history = [];
  Future getSharedPrefs2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    history = (prefs.getStringList("historyUser") != null)
        ? prefs.getStringList("historyUser")!
        : [];
  }

  @override
  void initState() {
    super.initState();
    fetchChats("");
    getToken();
    _list_recomondations_controller.addListener(() {
      if (_list_recomondations_controller.position.maxScrollExtent ==
          _list_recomondations_controller.offset) {
        fetchChats(_searchMessController.value.text);
      }
    });
    getSharedPrefs2();
  }

  @override
  void dispose() {
    super.dispose();
    _list_recomondations_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorPalette.backgroundcolor,
        child: Column(
          children: [
            WidgetsModels.title(context),
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20).w,
              child: Focus(
                  focusNode: focus,
                  onFocusChange: (value) {
                    setState(() {
                      searchfocus = !searchfocus;
                    });
                  },
                  child: WidgetsModels.searchbar(
                    _searchcontroller, 250.w,
                    "Search for users",

                    //prefix
                    GestureDetector(
                        //set shared preferences
                        onTap: () async {
                          SharedPreferences sharedPreferences =
                              await SharedPreferences.getInstance();
                          history = (sharedPreferences
                                      .getStringList("historyUser") !=
                                  null)
                              ? sharedPreferences.getStringList("historyUser")!
                              : [];
                          if (!history.contains(_searchcontroller.value.text) &&
                              _searchcontroller.value.text != "") {
                            history.insert(0, _searchcontroller.value.text);
                          }
                          setState(() {
                            sharedPreferences.setStringList(
                                "historyUser", history);

                            search(_searchcontroller.value.text);
                            if (focus.hasFocus) {
                              focus.unfocus();
                            } else {
                              FocusScope.of(context).requestFocus(focus);
                            }
                          });
                        },
                        child: Icon(
                          FluentIcons.search_20_regular,
                          color: ColorPalette.SH_Grey900,
                        )),
                    //suffix
                    null,
                    //onchanged
                    (p0) => (),
                    //onsubmitted
                    (p0) async {
                      SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      history =
                          (sharedPreferences.getStringList("historyUser") !=
                                  null)
                              ? sharedPreferences.getStringList("historyUser")!
                              : [];
                      if (!history.contains(_searchcontroller.value.text) &&
                          _searchcontroller.value.text != "") {
                        history.insert(0, _searchcontroller.value.text);
                      }
                      {
                        setState(() {
                          sharedPreferences.setStringList(
                              "historyUser", history);
                          focus.unfocus();
                        });
                        search(_searchcontroller.value.text);
                      }
                    },
                  )),
            ),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: !searchfocus
                    ? RefreshIndicator(
                        onRefresh: refresh,
                        color: ColorPalette.Primary_Color_Light,
                        backgroundColor: ColorPalette.SH_Grey100,
                        child: ListView.builder(
                          controller: _list_recomondations_controller,
                          scrollDirection: Axis.vertical,
                          itemCount: messages.length + 1,
                          itemBuilder: (context, i) {
                            if (i < messages.length) {
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.pushNamed(RoutesName.chat,
                                          pathParameters: {
                                            "id": messages[i].c.id,
                                            "name": messages[i].recipient.name,
                                            'image':
                                                "${config.http}/${messages[i].recipient.photo}",
                                            "member1": messages[i].c.members[0],
                                            "member2": messages[i].c.members[1],
                                            "token": token!,
                                          });
                                    },
                                    child: Row(
                                      children: [
                                        WidgetsModels.Container_widget(
                                            50.w,
                                            50.h,
                                            Alignment.topLeft,
                                            const EdgeInsets.only(
                                                    bottom: 16,
                                                    left: 16,
                                                    right: 13,
                                                    top: 20)
                                                .w,
                                            BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        "${config.http}/${messages[i].recipient.photo}"),
                                                    fit: BoxFit.cover)),
                                            null),
                                        Column(
                                          children: [
                                            WidgetsModels.Container_widget(
                                              190.w,
                                              22.h,
                                              Alignment.topLeft,
                                              const EdgeInsets.only(
                                                      top: 10, right: 30)
                                                  .w,
                                              null,
                                              Text(messages[i].recipient.name,
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            ),
                                            if (messages[i].lastMessage != null)
                                              WidgetsModels.Container_widget(
                                                190.w,
                                                22.h,
                                                null,
                                                EdgeInsets.only(right: 28).w,
                                                null,
                                                Text(
                                                    messages[i]
                                                                .lastMessage!
                                                                .text
                                                                .length >
                                                            25
                                                        ? "${messages[i].lastMessage!.text.substring(0, 25)}..."
                                                        : messages[i]
                                                            .lastMessage!
                                                            .text,
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            color:
                                                                ColorPalette
                                                                    .SH_Grey100,
                                                            fontSize: 10.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                          ],
                                        ),
                                        if (messages[i].lastMessage != null)
                                          WidgetsModels.Container_widget(
                                            30.w,
                                            22.h,
                                            null,
                                            const EdgeInsets.only(right: 10).w,
                                            null,
                                            Text(
                                                TextString.timeAgoSinceDate(
                                                    messages[i]
                                                        .lastMessage!
                                                        .createdAt
                                                        .toIso8601String()),
                                                style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorPalette.SH_Grey300,
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ),
                                      ],
                                    ),
                                  ),
                                  WidgetsModels.Container_widget(
                                      null,
                                      1.h,
                                      null,
                                      null,
                                      BoxDecoration(
                                          color: ColorPalette.SH_Grey100),
                                      null),
                                ],
                              );
                            } else {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 32).w,
                                child: Center(
                                    child: hasmore
                                        ? CircularProgressIndicator(
                                            color: ColorPalette
                                                .Primary_Color_Light,
                                          )
                                        : Text(
                                            'No More Chats',
                                            style: GoogleFonts.montserrat(
                                                color: ColorPalette.SH_Grey100,
                                                fontSize: 14.sp,
                                                fontWeight: FontWeight.w500),
                                          )),
                              );
                            }
                          },
                        ))
                    : SizedBox(
                        child: Column(
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
                                          fontSize: 16.sp,
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
                                                ? ColorPalette
                                                    .Secondary_Color_Light
                                                : ColorPalette.SH_Grey300,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )),
                              ],
                            ),
                            SizedBox(
                              height: MediaQuery.sizeOf(context).height - 560,
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: (seeall)
                                    ? history.length
                                    : min(history.length, 6),
                                itemBuilder: (context, i) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _searchcontroller.text = history[i];
                                        focus.unfocus();
                                        search(history[i]);
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
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
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
                                                                    "historyUser") !=
                                                            null)
                                                        ? sharedPreferences
                                                            .getStringList(
                                                                "historyUser")!
                                                        : [];
                                                    if (sharedPreferences
                                                            .getStringList(
                                                                "historyUser") !=
                                                        null) {
                                                      history.removeAt(i);
                                                    }
                                                    setState(() {
                                                      sharedPreferences
                                                          .setStringList(
                                                              "historyUser",
                                                              history);
                                                    });
                                                  },
                                                  child: Icon(
                                                    FluentIcons
                                                        .dismiss_24_regular,
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                  ))
                                            ],
                                          ),
                                          Container(
                                            color: ColorPalette.SH_Grey100,
                                            height: 1.h,
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
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
