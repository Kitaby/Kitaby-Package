// ignore_for_file: non_constant_identifier_names
import "dart:ui" as ui;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_comments_request_model.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_comments_response_model.dart';
import 'package:kitaby/models/Forum/Comments/GetComments/get_thread_reponse_model.dart';
import 'package:kitaby/models/Forum/Comments/PostComment/post_comment_request_model.dart';
import 'package:kitaby/models/Forum/Comments/PostReplys/post_reply_request_model.dart';
import 'package:kitaby/models/Forum/Home/GetThreads/get_threads_categories_response_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'CommunityWidgets.dart';

class CommentCommunity extends StatefulWidget {
  final String? id;
  const CommentCommunity({super.key, required this.id});

  @override
  State<CommentCommunity> createState() => CommentCommunityState();
}

class CommentCommunityState extends State<CommentCommunity> {
  final FocusNode _controllerTFfocusNode = FocusNode();
  late bool filled;
  late double numLines;
  late String content;
  late int level;
  late bool firsttime;
  final TextEditingController _controllerTF = TextEditingController();
  final ScrollController _list_recomondations_controller = ScrollController();
  late String type;
  String id = "";

  List<Comment> comments = [];
  List<int> pages = [];
  List<String> comments_array = [];
  bool hasmore = true;
  int page = 0;
  bool isloading = false;
  late DataR thread;
  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 0;
      comments.clear();
    });
    fetchrecomondations();
  }

  void setTypeId(String type1, String id1, int level1) {
    setState(() {
      type = type1;
      id = id1;
      level = level1;
    });
  }

  Future fetchrecomondations() async {
    if (isloading) return;
    isloading = true;
    if (page == 0) {
      GetThreadResponseModel response =
          await APISERVICES().getThread(widget.id);
      if (response.message == "success") {
        thread = response.thread!;
        comments_array = response.commentsArray!;
      }
    }
    GetCommentsRequestModel reqModel =
        GetCommentsRequestModel(commentsArray: comments_array);
    GetCommentsResponseModel responseModel =
        await APISERVICES().getComments(reqModel, page);
    if (responseModel.message == "success") {
      setState(() {
        page++;
        isloading = false;
        if (responseModel.comments.length < 6) {
          hasmore = false;
        }
        List<int> newpages =
            List<int>.generate(responseModel.comments.length, (counter) => 0);
        pages.addAll(newpages);
        comments.addAll(responseModel.comments);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchrecomondations();
    numLines = 1;
    filled = false;
    type = "comment";
    level = 0;
    content = "";
    firsttime = true;
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
            WidgetsModels.title(context),
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(top: 5, left: 20, right: 20).w,
                  child: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification: (overScroll) {
                      overScroll.disallowIndicator();
                      return true;
                    },
                    child: RefreshIndicator(
                      color: ColorPalette.Primary_Color_Light,
                      backgroundColor: ColorPalette.SH_Grey100,
                      onRefresh: refresh,
                      child: ListView.builder(
                          controller: _list_recomondations_controller,
                          itemCount: comments.length + 1,
                          itemBuilder: (context, i) {
                            if (i < comments.length) {
                              if (i == 0) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                              bottom: 30, left: 5, right: 5)
                                          .w,
                                      child: CommunityWidgets.Reddit(
                                          thread,
                                          _controllerTFfocusNode,
                                          context,
                                          id,
                                          type,
                                          refresh,
                                          setTypeId),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                              bottom: 20, left: 5, right: 5)
                                          .w,
                                      child: CommunityWidgets.RedditComment(
                                          pages[i],
                                          comments[i],
                                          _controllerTFfocusNode,
                                          _controllerTF,
                                          context,
                                          refresh,
                                          setTypeId),
                                    ),
                                  ],
                                );
                              } else {
                                return Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 15, left: 5, right: 5),
                                  child: CommunityWidgets.RedditComment(
                                      pages[i],
                                      comments[i],
                                      _controllerTFfocusNode,
                                      _controllerTF,
                                      context,
                                      refresh,
                                      setTypeId),
                                );
                              }
                            } else {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 200),
                                child: (i != 0)
                                    ? Center(
                                        child: hasmore
                                            ? CircularProgressIndicator(
                                                color: ColorPalette
                                                    .Primary_Color_Light,
                                              )
                                            : Text(
                                                'No More Comments',
                                                style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ))
                                    : hasmore
                                        ? Center(
                                            child: CircularProgressIndicator(
                                            color: ColorPalette
                                                .Primary_Color_Light,
                                          ))
                                        : Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 30,
                                                  left: 5,
                                                  right: 5),
                                              child: CommunityWidgets.Reddit(
                                                  thread,
                                                  _controllerTFfocusNode,
                                                  context,
                                                  id,
                                                  type,
                                                  refresh,
                                                  setTypeId),
                                            ),
                                            Text(
                                              'No More Comments',
                                              style: GoogleFonts.montserrat(
                                                  color:
                                                      ColorPalette.SH_Grey100,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ]),
                              );
                            }
                          }),
                    ),
                  )),
            ),
            StatefulBuilder(builder: (context, setStateTF) {
              return Container(
                color: ColorPalette.Primary_Color_Original,
                child: WidgetsModels.Container_widget(
                  null,
                  numLines <= 2 ? 20.w + numLines * 20.w : 80.w,
                  Alignment.center,
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 15).w,
                  BoxDecoration(
                      color: ColorPalette.SH_Grey100,
                      borderRadius: BorderRadius.circular(100).r),
                  TextField(
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey900,
                        fontWeight: FontWeight.w400),
                    cursorColor: ColorPalette.Primary_Color_Light,
                    controller: _controllerTF,
                    focusNode: _controllerTFfocusNode,
                    cursorWidth: 1.w,
                    onChanged: (text) {
                      setStateTF(() {
                        filled = text != "";
                        TextPainter tp = TextPainter(
                          text: TextSpan(
                            text: text,
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontWeight: FontWeight.w400),
                          ),
                          textDirection: ui.TextDirection.ltr,
                          maxLines: 3,
                        );
                        // const _kCaretGap can be found in editable.dart file
                        const caretGap = 1;
                        tp.layout(
                            maxWidth: context.size!.width -
                                caretGap -
                                1.w -
                                24.w -
                                28.w -
                                100.w -
                                25.w);
                        if (tp.computeLineMetrics().isEmpty) {
                          numLines = 1;
                        } else {
                          numLines = tp.computeLineMetrics().length + 0.0;
                        }
                      });
                    },
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "Write here ...",
                        contentPadding: const EdgeInsets.only(
                                left: 20, top: 7, right: 12, bottom: 10)
                            .w,
                        suffixIcon: filled
                            ? GestureDetector(
                                child: const Icon(FluentIcons.send_16_regular),
                                onTap: () async {
                                  setStateTF(() {
                                    if (_controllerTF.text.indexOf(' ', 2) !=
                                        -1) {
                                      content = _controllerTF.text.substring(
                                          _controllerTF.text.indexOf(' ', 2));
                                    } else {
                                      content = _controllerTF.text;
                                    }
                                    _controllerTF.text = "";
                                    numLines = 1;
                                    filled = false;
                                  });
                                  if (content.isNotEmpty &&
                                      RegExp(r'[A-Za-z0-9_.\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=]')
                                          .hasMatch(content)) {
                                    FocusScope.of(context).unfocus();
                                    if (type == "comment") {
                                      PostCommentRequestModel requestModel =
                                          PostCommentRequestModel(
                                              thread: thread.id,
                                              content: content);
                                      await APISERVICES()
                                          .postComment(requestModel)
                                          .then((response) => {
                                                if (response.message ==
                                                    "success")
                                                  {
                                                    refresh().then((value) =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(WidgetsModels
                                                                .Dialog_Message(
                                                                    "success",
                                                                    "Posting successed",
                                                                    "You comment has been posted"))),
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
                                    } else if (type == "reply") {
                                      if (level == 0) {
                                        PostReplyRequestModel requestModel =
                                            PostReplyRequestModel(
                                                reply: '',
                                                content: content,
                                                comment: id);
                                        await APISERVICES()
                                            .postReply(requestModel)
                                            .then((response) => {
                                                  if (response.message ==
                                                      "success")
                                                    {
                                                      refresh().then((value) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(WidgetsModels
                                                                  .Dialog_Message(
                                                                      "success",
                                                                      "Posting successed",
                                                                      "Your comment has been posted"))),
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
                                        PostReplyRequestModel requestModel =
                                            PostReplyRequestModel(
                                                reply: id,
                                                content: content,
                                                comment: "");
                                        await APISERVICES()
                                            .postReply(requestModel)
                                            .then((response) => {
                                                  if (response.message ==
                                                      "success")
                                                    {
                                                      refresh().then((value) =>
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(WidgetsModels
                                                                  .Dialog_Message(
                                                                      "success",
                                                                      "Posting successed",
                                                                      "Your reply has been posted"))),
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
                                    }
                                  }
                                },
                              )
                            : null),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
