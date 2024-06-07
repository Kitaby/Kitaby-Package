// ignore_for_file: no_leading_underscores_for_local_identifiers, file_names, use_build_context_synchronously
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kitaby/models/config.dart';
// ignore_for_file: non_constant_identifier_names
import 'package:kitaby/Constants/Colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_comments_response_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_response_model.dart';
import 'package:kitaby/models/Forum/Home/LikeThread/like_thread_request_model.dart';
import 'package:kitaby/models/Forum/Home/ReportThread/report_request_model.dart';
import 'package:kitaby/models/Forum/Home/deleteThread/delete_thread_request_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/profile/get_post_response_model.dart';

class CommunityWidgets {
  static Card Reddit(
      DataR thread,
      FocusNode? focusnode,
      BuildContext context,
      String id,
      String type,
      Future Function() refresh,
      void Function(String, String, int) set) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      color: ColorPalette.SH_Grey100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10).w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                WidgetsModels.Container_widget(
                    40.w,
                    40.h,
                    Alignment.topLeft,
                    const EdgeInsets.only(
                            left: 15, right: 5, bottom: 15, top: 13)
                        .w,
                    BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: NetworkImage(
                                "${config.http}/${thread.authorPhoto}"),
                            fit: BoxFit.cover)),
                    null),
                Container(
                  width: 140.w,
                  padding: const EdgeInsets.only(left: 5.0, bottom: 3.0).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(thread.replyTo,
                          style: GoogleFonts.montserrat(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: ColorPalette.SH_Grey900)),
                      Text(thread.authorName,
                          style: GoogleFonts.montserrat(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.SH_Grey900)),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 70).w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isDismissible: true,
                              context: context,
                              builder: (ctx) => Container(
                                  color: ColorPalette.Primary_Color_Dark,
                                  height: thread.isAuthor ? 120.h : 60.h,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          ctx.pop();
                                          GetPostResponseModel
                                              getPostResponseModel =
                                              await APISERVICES().getPost();
                                          if (getPostResponseModel.message ==
                                              "success") {
                                            showDialog(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                content: StatefulBuilder(
                                                    builder:
                                                        (context, setDialog) {
                                                  TextEditingController
                                                      _content_controller =
                                                      TextEditingController();
                                                  bool isStreched = true;
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          WidgetsModels.Container_widget(
                                                              40.w,
                                                              40.h,
                                                              Alignment.topLeft,
                                                              const EdgeInsets
                                                                      .only(
                                                                      bottom:
                                                                          10,
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
                                                                      const EdgeInsets
                                                                              .only(
                                                                              top: 10,
                                                                              bottom: 10,
                                                                              left: 10,
                                                                              right: 20)
                                                                          .w,
                                                                      null,
                                                                      Text(
                                                                        getPostResponseModel
                                                                            .name,
                                                                        style: GoogleFonts.montserrat(
                                                                            color:
                                                                                ColorPalette.SH_Grey900,
                                                                            fontSize: 12.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                      )),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      TextField(
                                                        controller:
                                                            _content_controller,
                                                        maxLines: 3,
                                                        decoration:
                                                            InputDecoration(
                                                          prefixIcon: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            32)
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
                                                              "Enter Why you want to report this thread",
                                                          hintStyle: GoogleFonts
                                                              .montserrat(
                                                                  color: ColorPalette
                                                                      .SH_Grey900,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: const EdgeInsets
                                                                .only(top: 20)
                                                            .w,
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    GestureDetector(
                                                              child: WidgetsModels.button1(
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
                                                            SizedBox(
                                                                width: 50.w),
                                                            Expanded(
                                                              child: StatefulBuilder(
                                                                  builder: (contextbtn, setStatebtn) => GestureDetector(
                                                                      onTap: () async {
                                                                        if (_content_controller
                                                                            .value
                                                                            .text
                                                                            .isNotEmpty) {
                                                                          setStatebtn(
                                                                              () {
                                                                            isStreched =
                                                                                false;
                                                                          });
                                                                          await Future.delayed(
                                                                              const Duration(seconds: 1));
                                                                          ReportRequestModel
                                                                              report =
                                                                              ReportRequestModel(
                                                                            reported:
                                                                                thread.id,
                                                                            description:
                                                                                _content_controller.value.text,
                                                                            model:
                                                                                'thread',
                                                                          );
                                                                          await APISERVICES().reportThread(report).then((response) =>
                                                                              {
                                                                                setStatebtn(() {
                                                                                  isStreched = true;
                                                                                }),
                                                                                if (response.message == "success")
                                                                                  {
                                                                                    context.pop(),
                                                                                    refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message("success", "Report successed", "You thread has been reported"))),
                                                                                  }
                                                                                else if (response.message == "already reported")
                                                                                  {
                                                                                    context.pop(),
                                                                                    refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message("help", "Already Reported", "You already reported this thread "))),
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
                                                                      child: isStreched ? WidgetsModels.button1(120, 30, ColorPalette.Secondary_Color_Orignal, FluentIcons.arrow_clockwise_dashes_16_regular, ColorPalette.SH_Grey100, "Post") : WidgetsModels.buildSmallGreenButton())),
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
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                                  top: 10,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10)
                                              .w,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                        right: 10)
                                                    .w,
                                                child: Icon(
                                                  FluentIcons.flag_20_regular,
                                                  color:
                                                      ColorPalette.SH_Grey100,
                                                ),
                                              ),
                                              Text("Report",
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: ColorPalette
                                                          .SH_Grey100)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (thread.isAuthor)
                                        GestureDetector(
                                          onTap: () async {
                                            DeleteThreadRequestModel
                                                requestModel =
                                                DeleteThreadRequestModel(
                                                    id: thread.id);
                                            ctx.pop();
                                            await APISERVICES()
                                                .deleteThread(requestModel)
                                                .then((response) => {
                                                      if (response.message ==
                                                          "success")
                                                        {
                                                          refresh().then((value) => ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(WidgetsModels
                                                                  .Dialog_Message(
                                                                      "success",
                                                                      "Delete successed",
                                                                      "You thread has been deleted"))),
                                                        }
                                                      else
                                                        {
                                                          refresh().then(
                                                            (value) => ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(WidgetsModels
                                                                    .Dialog_Message(
                                                                        "fail",
                                                                        "Unkwon error",
                                                                        "Please retry later")),
                                                          ),
                                                        }
                                                    });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 10)
                                                .w,
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                              right: 10)
                                                          .w,
                                                  child: Icon(
                                                    FluentIcons
                                                        .delete_20_regular,
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                  ),
                                                ),
                                                Text("Delete",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: ColorPalette
                                                                .SH_Grey100)),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  )));
                        },
                        child: Icon(
                          FluentIcons.more_horizontal_16_filled,
                          color: ColorPalette.SH_Grey900,
                          size: 20.sp,
                        ),
                      ),
                      Text(
                          TextString.timeAgoSinceDate(
                              thread.createdAt.toIso8601String()),
                          style: GoogleFonts.montserrat(
                              fontSize: 5.sp,
                              fontWeight: FontWeight.w400,
                              color: ColorPalette.SH_Grey900)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 15).w,
            child: Text(thread.title,
                style: GoogleFonts.montserrat(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: ColorPalette.SH_Grey900)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25, right: 25).w,
            child: Text(thread.content,
                style: GoogleFonts.montserrat(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: ColorPalette.SH_Grey900)),
          ),
          StatefulBuilder(builder: (context, setLikes) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    LikeThreadRequestModel requestModel =
                        LikeThreadRequestModel(id: thread.id);
                    await APISERVICES().likeThread(requestModel).then(
                      (value) {
                        setLikes(() {
                          thread.alreadyLiked = !thread.alreadyLiked;
                          if (thread.alreadyLiked) {
                            thread.upvotes += 1;
                          } else {
                            thread.upvotes -= 1;
                          }
                        });
                      },
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 20).w,
                    child: Icon(
                      thread.alreadyLiked
                          ? FluentIcons.thumb_like_16_filled
                          : FluentIcons.thumb_like_16_regular,
                      color: ColorPalette.SH_Grey500,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7, bottom: 20).w,
                  child: Text("${thread.upvotes}",
                      style: GoogleFonts.montserrat(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.SH_Grey500)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (focusnode != null) {
                          set("comment", thread.id, -1);
                          FocusScope.of(context).requestFocus(focusnode);
                        } else {
                          context.pushNamed(RoutesName.PostPage,
                              pathParameters: {"id": thread.id});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 20).w,
                        child: Icon(
                          FluentIcons.comment_16_regular,
                          color: ColorPalette.SH_Grey500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7, bottom: 20).w,
                      child: Text("${thread.numreplies}",
                          style: GoogleFonts.montserrat(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorPalette.SH_Grey500)),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await APISERVICES().shareThread(thread.id).then(
                          (value) {
                            setLikes(() {
                              thread.shares += 1;
                            });
                          },
                        );
                        await Clipboard.setData(ClipboardData(
                                text:
                                    "https://kitaby.com/Home/Community/PostPage/${thread.id}"))
                            .then((value) => {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      WidgetsModels.Dialog_Message(
                                          "info",
                                          "Copied",
                                          "You url has been copied to \n your clipboard"))
                                });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25, bottom: 20).w,
                        child: Icon(
                          FluentIcons.share_16_regular,
                          color: ColorPalette.SH_Grey500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 7, bottom: 20).w,
                      child: Text("${thread.shares} ",
                          style: GoogleFonts.montserrat(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w500,
                              color: ColorPalette.SH_Grey500)),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  static Column RedditReply(
      Comment? comment,
      Somereply? reply,
      String ReplyId,
      String imageLink,
      String username,
      String date,
      String Userreplying,
      List<Somereply> Replys,
      String ReplyedtoID,
      String Content,
      int level,
      bool owned,
      FocusNode focusNode,
      TextEditingController _controllerTF,
      BuildContext context,
      Function(int) ScrollTo,
      Future Function() refresh,
      void Function(String, String, int) set) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            WidgetsModels.Container_widget(
                35.w,
                35.h,
                Alignment.topLeft,
                const EdgeInsets.only(left: 15, right: 10, top: 15).w,
                BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage("${config.http}/$imageLink"),
                        fit: BoxFit.cover)),
                null),
            Container(
              width: 120.w,
              margin: const EdgeInsets.only(top: 10, left: 5).w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: GoogleFonts.montserrat(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.SH_Grey900)),
                  Text(date,
                      style: GoogleFonts.montserrat(
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorPalette.SH_Grey900)),
                ],
              ),
            ),
            Container(
              margin: (level == 0)
                  ? const EdgeInsets.only(
                          top: 30, left: 65, right: 25, bottom: 15)
                      .w
                  : const EdgeInsets.only(
                          top: 30, left: 40, right: 25, bottom: 15)
                      .w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          isDismissible: true,
                          context: context,
                          builder: (ctx) => Container(
                              color: ColorPalette.Primary_Color_Dark,
                              height: owned ? 120.h : 60.h,
                              width: double.infinity,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      ctx.pop();
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
                                              TextEditingController
                                                  _content_controller =
                                                  TextEditingController();
                                              bool isStreched = true;
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
                                                          "Enter Why you want to report this thread",
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
                                                                            if (_content_controller.value.text.isNotEmpty) {
                                                                              setStatebtn(() {
                                                                                isStreched = false;
                                                                              });
                                                                              await Future.delayed(const Duration(seconds: 1));
                                                                              ReportRequestModel report;
                                                                              if (level == 0) {
                                                                                report = ReportRequestModel(
                                                                                  reported: ReplyId,
                                                                                  description: _content_controller.value.text,
                                                                                  model: 'comment',
                                                                                );
                                                                              } else {
                                                                                report = ReportRequestModel(
                                                                                  reported: ReplyId,
                                                                                  description: _content_controller.value.text,
                                                                                  model: 'reply',
                                                                                );
                                                                              }
                                                                              await APISERVICES().reportThread(report).then((response) => {
                                                                                    setStatebtn(() {
                                                                                      isStreched = true;
                                                                                    }),
                                                                                    if (response.message == "success")
                                                                                      {
                                                                                        context.pop(),
                                                                                        refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message("success", "Report successed", "You thread has been reported"))),
                                                                                      }
                                                                                    else if (response.message == "already reported")
                                                                                      {
                                                                                        context.pop(),
                                                                                        refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message("help", "Already Reported", "You already reported this thread "))),
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                              top: 10,
                                              left: 10,
                                              right: 10,
                                              bottom: 10)
                                          .w,
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(right: 10)
                                                    .w,
                                            child: Icon(
                                              FluentIcons.flag_20_regular,
                                              color: ColorPalette.SH_Grey100,
                                            ),
                                          ),
                                          Text("Report",
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w400,
                                                  color:
                                                      ColorPalette.SH_Grey100)),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (owned)
                                    GestureDetector(
                                      onTap: () async {
                                        DeleteThreadRequestModel requestModel =
                                            DeleteThreadRequestModel(
                                                id: ReplyId);
                                        ctx.pop();
                                        if (level == 0) {
                                          await APISERVICES()
                                              .deleteComment(requestModel)
                                              .then((response) => {
                                                    if (response.message ==
                                                        "success")
                                                      {
                                                        refresh().then((value) => ScaffoldMessenger
                                                                .of(context)
                                                            .showSnackBar(WidgetsModels
                                                                .Dialog_Message(
                                                                    "success",
                                                                    "Delete successed",
                                                                    "You Comment has been deleted"))),
                                                      }
                                                    else
                                                      {
                                                        refresh().then(
                                                          (value) => ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(WidgetsModels
                                                                  .Dialog_Message(
                                                                      "fail",
                                                                      "Unkwon error",
                                                                      "Please retry later")),
                                                        ),
                                                      }
                                                  });
                                        } else {
                                          await APISERVICES()
                                              .deleteReply(requestModel)
                                              .then((response) => {
                                                    if (response.message ==
                                                        "success")
                                                      {
                                                        refresh().then((value) => ScaffoldMessenger
                                                                .of(context)
                                                            .showSnackBar(WidgetsModels
                                                                .Dialog_Message(
                                                                    "success",
                                                                    "Delete successed",
                                                                    "You Reply has been deleted"))),
                                                      }
                                                    else
                                                      {
                                                        refresh().then(
                                                          (value) => ScaffoldMessenger
                                                                  .of(context)
                                                              .showSnackBar(WidgetsModels
                                                                  .Dialog_Message(
                                                                      "fail",
                                                                      "Unkwon error",
                                                                      "Please retry later")),
                                                        ),
                                                      }
                                                  });
                                        }
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                                top: 10,
                                                left: 10,
                                                right: 10,
                                                bottom: 10)
                                            .w,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                      right: 10)
                                                  .w,
                                              child: Icon(
                                                FluentIcons.delete_20_regular,
                                                color: ColorPalette.SH_Grey100,
                                              ),
                                            ),
                                            Text("Delete",
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 20.sp,
                                                    fontWeight: FontWeight.w400,
                                                    color: ColorPalette
                                                        .SH_Grey100)),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              )));
                    },
                    child: Icon(
                      FluentIcons.more_horizontal_16_filled,
                      color: ColorPalette.SH_Grey900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 80, bottom: 15, right: 25).w,
          child: Userreplying == ""
              ? RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: Container(
                        margin: const EdgeInsets.only(right: 10).w,
                        child: Text(Content,
                            style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorPalette.SH_Grey900)),
                      ),
                    ),
                  ]),
                )
              : RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          ScrollTo(Replys.indexWhere(
                              (element) => (element.id == ReplyedtoID)));
                        },
                        child: Text("@$Userreplying ",
                            style: GoogleFonts.montserrat(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: ColorPalette.SH_Grey900)),
                      ),
                    ),
                    TextSpan(
                      style: GoogleFonts.montserrat(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.SH_Grey900),
                      text: Content,
                    ),
                  ]),
                ),
        ),
        StatefulBuilder(builder: (context, setLikes) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  if (level == 0) {
                  } else {
                    LikeThreadRequestModel requestModel =
                        LikeThreadRequestModel(id: ReplyId);
                    await APISERVICES().likeReply(requestModel).then(
                      (value) {
                        setLikes(() {
                          reply!.alreadyLiked = !reply.alreadyLiked;
                          if (reply.alreadyLiked) {
                            reply.upvotes += 1;
                          } else {
                            reply.upvotes -= 1;
                          }
                        });
                      },
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 70, bottom: 5).w,
                  child: Icon(
                    (level == 0)
                        ? comment!.alreadyLiked
                            ? FluentIcons.thumb_like_16_filled
                            : FluentIcons.thumb_like_16_regular
                        : reply!.alreadyLiked
                            ? FluentIcons.thumb_like_16_filled
                            : FluentIcons.thumb_like_16_regular,
                    color: ColorPalette.SH_Grey500,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 7, bottom: 5).w,
                child: Text(
                    (level == 0) ? "${comment!.upvotes}" : "${reply!.upvotes}",
                    style: GoogleFonts.montserrat(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                        color: ColorPalette.SH_Grey500)),
              ),
              GestureDetector(
                onTap: () {
                  set("reply", ReplyId, level);
                  _controllerTF.text = "@$username";
                  _controllerTF.selection = TextSelection.fromPosition(
                      TextPosition(offset: _controllerTF.text.length));
                  FocusScope.of(context).requestFocus(focusNode);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 5).w,
                  child: Text("Reply",
                      style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: ColorPalette.SH_Grey500)),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  static Card RedditComment(
      int replyspage,
      Comment comment,
      FocusNode focusNode,
      TextEditingController _controllerTF,
      BuildContext context,
      Future Function() refresh,
      void Function(String, String, int) set) {
    ScrollController scrolling = ScrollController();
    void ScrollTo(int placement) {
      final contentSize = scrolling.position.viewportDimension +
          scrolling.position.maxScrollExtent;
      final index = placement;
      final target = contentSize * index / comment.somereplies.length;
      scrolling.position.animateTo(
        target,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(7.0),
      ),
      color: ColorPalette.SH_Grey100,
      child: SizedBox(
        height: comment.somereplies.isEmpty
            ? 170.h
            : comment.somereplies.length == 1
                ? 340.h
                : 400.h,
        width: double.infinity,
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowIndicator();
            return true;
          },
          child: StatefulBuilder(
            builder: (contextcomment, setStatecomment) {
              return SizedBox(
                child: ListView.builder(
                  controller: scrolling,
                  scrollDirection: Axis.vertical,
                  itemCount: comment.somereplies.length + 1,
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return Column(
                        children: [
                          RedditReply(
                            comment,
                            null,
                            comment.id,
                            comment.authorPhoto,
                            comment.authorName,
                            "${comment.createdAt.year} / ${comment.createdAt.month} / ${comment.createdAt.day}",
                            "",
                            comment.somereplies,
                            comment.replyTo,
                            comment.content,
                            0,
                            comment.isAuthor,
                            focusNode,
                            _controllerTF,
                            context,
                            ScrollTo,
                            refresh,
                            set,
                          ),
                          if (i < comment.somereplies.length)
                            Container(
                                margin: const EdgeInsets.only(left: 25).w,
                                child: RedditReply(
                                    null,
                                    comment.somereplies[i],
                                    comment.somereplies[i].id,
                                    comment.somereplies[i].authorPhoto,
                                    comment.somereplies[i].authorName,
                                    "${comment.somereplies[i].createdAt.year} / ${comment.somereplies[i].createdAt.month} / ${comment.somereplies[i].createdAt.day}",
                                    comment.somereplies[i].replyTo.username,
                                    comment.somereplies,
                                    comment.somereplies[i].replyTo.id,
                                    comment.somereplies[i].content,
                                    1,
                                    comment.somereplies[i].isAuthor,
                                    focusNode,
                                    _controllerTF,
                                    context,
                                    ScrollTo,
                                    refresh,
                                    set))
                          else
                            Container(
                              margin: const EdgeInsets.only(
                                      top: 10, right: 20, bottom: 10)
                                  .w,
                              padding: const EdgeInsets.only(bottom: 5).w,
                              child: Text("No more replys",
                                  style: GoogleFonts.montserrat(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500,
                                      color: ColorPalette.SH_Grey500)),
                            ),
                        ],
                      );
                    }
                    if (i < comment.somereplies.length) {
                      if (i > 0) {
                        return Container(
                            margin: const EdgeInsets.only(left: 25).w,
                            child: RedditReply(
                                null,
                                comment.somereplies[i],
                                comment.somereplies[i].id,
                                comment.somereplies[i].authorPhoto,
                                comment.somereplies[i].authorName,
                                "${comment.somereplies[i].createdAt.year} / ${comment.somereplies[i].createdAt.month} / ${comment.somereplies[i].createdAt.day}",
                                comment.somereplies[i].replyTo.username,
                                comment.somereplies,
                                comment.somereplies[i].replyTo.id,
                                comment.somereplies[i].content,
                                1,
                                comment.somereplies[i].isAuthor,
                                focusNode,
                                _controllerTF,
                                context,
                                ScrollTo,
                                refresh,
                                set));
                      }
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10).w,
                        child: Center(
                          child: (comment.somereplies.length >
                                  3 * (replyspage) + 1)
                              ? GestureDetector(
                                  onTap: () async {
                                    await APISERVICES()
                                        .getReplies(comment.id, replyspage + 1)
                                        .then((response) => {
                                              if (response.message == "success")
                                                {
                                                  setStatecomment(() {
                                                    replyspage += 1;
                                                    comment.somereplies.addAll(
                                                        response.repliesArray);
                                                  })
                                                }
                                            });
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                            top: 10, right: 20)
                                        .w,
                                    padding: const EdgeInsets.only(bottom: 5).w,
                                    child: Text("See more",
                                        style: GoogleFonts.montserrat(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w500,
                                            color: ColorPalette.SH_Grey500)),
                                  ),
                                )
                              : Container(
                                  margin: const EdgeInsets.only(
                                          top: 10, right: 20, bottom: 10)
                                      .w,
                                  padding: const EdgeInsets.only(bottom: 5).w,
                                  child: Text("No more replys",
                                      style: GoogleFonts.montserrat(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.w500,
                                          color: ColorPalette.SH_Grey500)),
                                ),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static StatefulBuilder ChipModel(List<String> selecteditems, String ChipText,
      List<bool> isselected, int index, Future Function() resset) {
    return StatefulBuilder(
      builder: (context, setStateChip) {
        return ChoiceChip(
          label: Row(
            children: [
              if (!isselected[index])
                Container(
                  margin: const EdgeInsets.only(right: 5).w,
                  child: Icon(
                    FluentIcons.add_16_regular,
                    color: ColorPalette.Secondary_Color_Orignal,
                    size: 18.sp,
                  ),
                ),
              Text(
                ChipText,
                style: GoogleFonts.montserrat(
                    color: (isselected[index])
                        ? ColorPalette.SH_Grey900
                        : ColorPalette.SH_Grey100,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          shape:
              StadiumBorder(side: BorderSide(color: ColorPalette.SH_Grey100)),
          selected: isselected[index],
          backgroundColor: ColorPalette.Primary_Color_Dark,
          selectedColor: ColorPalette.SH_Grey100,
          onSelected: (value) {
            setStateChip(() {
              isselected.removeAt(index);
              isselected.insert(index, value);
              if (isselected[index]) {
                selecteditems.add(ChipText);
              } else {
                selecteditems.remove(ChipText);
              }
            });
            resset();
          },
        );
      },
    );
  }
}
