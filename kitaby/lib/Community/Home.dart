// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, file_names
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:kitaby/models/config.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_categories_response_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_request_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_response_model.dart';
import 'package:kitaby/models/Forum/Home/PostThread/post_thread_request.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/profile/get_post_response_model.dart';

import 'CommunityWidgets.dart';

class HomeCommunity extends StatefulWidget {
  const HomeCommunity({super.key});

  @override
  State<HomeCommunity> createState() => HomeCommunityState();
}

class HomeCommunityState extends State<HomeCommunity> {
  List<bool> isselected = List.generate(
    TextString.category.length,
    (index) {
      return false;
    },
  );
  bool isStreched = true;
  List<String> selected = [];
  static String? selectedCategory = TextString.category[0];
  List<DataR> posts = [];
  List<Datum> data = [];
  bool hasmore = true;
  int page = 0;
  bool isloading = false;
  final ScrollController _list_recomondations_controller = ScrollController();
  final TextEditingController _title_controller = TextEditingController();
  final TextEditingController _content_controller = TextEditingController();
  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 0;
      posts.clear();
    });
    fetchrecomondations();
  }

  void setTypeId(String type1, String id1, int level1) {}

  Future fetchrecomondations() async {
    if (isloading) return;
    isloading = true;
    if (page == 0) {
      GetCategoriesResponseModel response = await APISERVICES().getcategories();
      if (response.data != null) {
        data = response.data!;
      }
    }

    GetThreadCategoriesRequestModel responsebody =
        GetThreadCategoriesRequestModel(
            categories: selected.isEmpty ? TextString.category : selected,
            data: data);
    GetThreadCategoriesResponseModel responseModel =
        await APISERVICES().getThreads(responsebody, page);
    if (responseModel.data != null) {
      setState(() {
        page++;
        isloading = false;
        if (responseModel.data!.length < 6) {
          hasmore = false;
        }
        posts.addAll(responseModel.data!);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchrecomondations();
    _list_recomondations_controller.addListener(() {
      if (_list_recomondations_controller.position.maxScrollExtent ==
          _list_recomondations_controller.offset) {
        fetchrecomondations();
      }
    });
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
            WidgetsModels.titlenr(),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 10).w,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Container(
                          padding:
                              const EdgeInsets.only(left: 15, bottom: 15).w,
                          child: Text(
                            "Categories",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                            left: 25,
                            right: 25,
                          ).w,
                          width: double.infinity,
                          height: 50.h,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: TextString.category.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(right: 10).w,
                                  child: CommunityWidgets.ChipModel(
                                      selected,
                                      TextString.category[index],
                                      isselected,
                                      index,
                                      refresh));
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 25).w,
                          height: 700.h,
                          width: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 15).w,
                                child: RefreshIndicator(
                                  color: ColorPalette.Primary_Color_Light,
                                  backgroundColor: ColorPalette.SH_Grey100,
                                  onRefresh: refresh,
                                  child: ListView.builder(
                                      controller:
                                          _list_recomondations_controller,
                                      itemCount: posts.length + 1,
                                      itemBuilder: (context, i) {
                                        if (i < posts.length) {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                    bottom: 15,
                                                    left: 10,
                                                    right: 10)
                                                .w,
                                            child: CommunityWidgets.Reddit(
                                                posts[i],
                                                null,
                                                context,
                                                "",
                                                "",
                                                refresh,
                                                setTypeId),
                                          );
                                        } else {
                                          return Container(
                                            margin: const EdgeInsets.only(
                                                    bottom: 200)
                                                .w,
                                            child: Center(
                                                child: hasmore
                                                    ? CircularProgressIndicator(
                                                        color: ColorPalette
                                                            .Primary_Color_Light,
                                                      )
                                                    : Text(
                                                        'No More Threads',
                                                        style: GoogleFonts
                                                            .montserrat(
                                                                color: ColorPalette
                                                                    .SH_Grey100,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      )),
                                          );
                                        }
                                      }),
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 200, top: 370)
                                        .w,
                                child: SizedBox(
                                  width: 200.w,
                                  height: 50.h,
                                  child: FloatingActionButton.extended(
                                    onPressed: () async {
                                      GetPostResponseModel
                                          getPostResponseModel =
                                          await APISERVICES().getPost();
                                      if (getPostResponseModel.message ==
                                          "success") {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: StatefulBuilder(
                                                builder: (context, setDialog) {
                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Row(
                                                    children: [
                                                      WidgetsModels.Container_widget(
                                                          40.w,
                                                          40.h,
                                                          Alignment.topLeft,
                                                          const EdgeInsets.only(
                                                                  bottom: 10,
                                                                  top: 11.5)
                                                              .w,
                                                          BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      "${config.http}/${getPostResponseModel.pp}"),
                                                                  fit: BoxFit
                                                                      .cover)),
                                                          null),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          WidgetsModels
                                                              .Container_widget(
                                                                  null,
                                                                  null,
                                                                  null,
                                                                  const EdgeInsets.only(
                                                                          top:
                                                                              10,
                                                                          bottom:
                                                                              10,
                                                                          left:
                                                                              10,
                                                                          right:
                                                                              20)
                                                                      .w,
                                                                  null,
                                                                  Text(
                                                                    getPostResponseModel
                                                                        .name,
                                                                    style: GoogleFonts.montserrat(
                                                                        color: ColorPalette
                                                                            .SH_Grey900,
                                                                        fontSize: 12
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                                top: 15,
                                                                bottom: 15)
                                                            .w,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: ColorPalette
                                                                .SH_Grey900,
                                                            width: 0.5)),
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                    ).w,
                                                    child:
                                                        DropdownButton<String>(
                                                      value: selectedCategory,
                                                      items: TextString.category
                                                          .map((item) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                                value: item,
                                                                child: Text(
                                                                    item,
                                                                    style: GoogleFonts.montserrat(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        color: ColorPalette
                                                                            .SH_Grey900)),
                                                              ))
                                                          .toList(),
                                                      onChanged: (item) =>
                                                          setDialog(() =>
                                                              selectedCategory =
                                                                  item),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                                bottom: 10)
                                                            .w,
                                                    child: TextField(
                                                      controller:
                                                          _title_controller,
                                                      maxLines: 1,
                                                      decoration:
                                                          InputDecoration(
                                                        prefixIcon: Icon(
                                                            FluentIcons
                                                                .text_field_16_regular,
                                                            color: ColorPalette
                                                                .SH_Grey900),
                                                        border:
                                                            const OutlineInputBorder(),
                                                        hintText:
                                                            "Enter The Title here !",
                                                        hintStyle: GoogleFonts
                                                            .montserrat(
                                                                color: ColorPalette
                                                                    .SH_Grey900,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  TextField(
                                                    controller:
                                                        _content_controller,
                                                    maxLines: 3,
                                                    decoration: InputDecoration(
                                                      prefixIcon: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                    bottom: 32)
                                                                .w,
                                                        child: Icon(
                                                            FluentIcons
                                                                .text_field_16_regular,
                                                            color: ColorPalette
                                                                .SH_Grey900),
                                                      ),
                                                      border:
                                                          const OutlineInputBorder(),
                                                      hintText:
                                                          "Enter your review here you only have 60 words !",
                                                      hintStyle: GoogleFonts
                                                          .montserrat(
                                                              color: ColorPalette
                                                                  .SH_Grey900,
                                                              fontSize: 14.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                    ),
                                                  ),
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                                top: 20)
                                                            .w,
                                                    child: Row(
                                                      children: [
                                                        Expanded(
                                                            child:
                                                                GestureDetector(
                                                          child: WidgetsModels
                                                              .button1(
                                                                  120.w,
                                                                  30.h,
                                                                  ColorPalette
                                                                      .Error,
                                                                  FluentIcons
                                                                      .calendar_cancel_16_filled,
                                                                  ColorPalette
                                                                      .SH_Grey100,
                                                                  "Cancel "),
                                                          onTap: () {
                                                            context.pop();
                                                          },
                                                        )),
                                                        SizedBox(width: 50.w),
                                                        Expanded(
                                                          child:
                                                              StatefulBuilder(
                                                                  builder: (contextbtn,
                                                                          setStatebtn) =>
                                                                      GestureDetector(
                                                                          onTap:
                                                                              () async {
                                                                            if (_title_controller.value.text.isNotEmpty &&
                                                                                _content_controller.value.text.isNotEmpty) {
                                                                              setStatebtn(() {
                                                                                isStreched = false;
                                                                              });
                                                                              await Future.delayed(const Duration(seconds: 1));
                                                                              PostThreadRequestModel thread = PostThreadRequestModel(title: _title_controller.value.text, content: _content_controller.value.text, categorie: selectedCategory!);
                                                                              await APISERVICES().postThread(thread).then((response) => {
                                                                                    setStatebtn(() {
                                                                                      isStreched = true;
                                                                                    }),
                                                                                    if (response.message == "success")
                                                                                      {
                                                                                        context.pop(),
                                                                                        refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message("success", "Posting successed", "You thread has been posted"))),
                                                                                      }
                                                                                    else
                                                                                      {
                                                                                        context.pop(),
                                                                                        refresh().then(
                                                                                          (value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message("fail", "Unkwon error", "Please retry later")),
                                                                                        ),
                                                                                      }
                                                                                  });
                                                                            }
                                                                          },
                                                                          child: isStreched
                                                                              ? WidgetsModels.button1(120.w, 30.h, ColorPalette.Secondary_Color_Orignal, FluentIcons.arrow_clockwise_dashes_16_regular, ColorPalette.SH_Grey100, "Post")
                                                                              : WidgetsModels.buildSmallGreenButton())),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                          ),
                                        );
                                      }
                                    },
                                    backgroundColor:
                                        ColorPalette.Primary_Color_Original,
                                    icon: Padding(
                                      padding: const EdgeInsets.all(10).w,
                                      child: Icon(
                                        FluentIcons.add_16_regular,
                                        color: ColorPalette.SH_Grey100,
                                      ),
                                    ),
                                    label: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15).w,
                                      child: Text(
                                        "Add a post",
                                        style: GoogleFonts.montserrat(
                                            color: ColorPalette.SH_Grey100,
                                            fontSize: 12.5.sp,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    shape: BeveledRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5).r),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
