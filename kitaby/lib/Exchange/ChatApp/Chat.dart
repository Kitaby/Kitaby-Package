// ignore_for_file: file_names
import 'dart:io';
import 'dart:ui' as ui;
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kitaby/Exchange/ChatApp/Message.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:kitaby/models/Exchnage/Chat/Messages/SendMessages/send_message_request_model.dart';
import 'package:kitaby/models/api_services.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Chat extends StatefulWidget {
  final String? token;
  final String? id;
  final String? name;
  final String? image;
  final String? member1;
  final String? member2;
  // final String? Senderid;
  // final String? recievedid;
  const Chat(
      {super.key,
      required this.id,
      required this.name,
      required this.image,
      required this.token,
      required this.member1,
      required this.member2});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controllerTF = TextEditingController();
  late IO.Socket socket;
  bool filled = false;
  double numLines = 1;
  List<Message> messages = [];
  Future getMessages() async {
    APISERVICES().getMessages(widget.id!).then((response) => {
          if (response.msgs != null)
            {
              for (int i = 0; i < response.msgs!.length; i++)
                {
                  messages.add(
                    Message(
                      text: response.msgs![i].text,
                      date: DateTime(
                          response.msgs![i].createdAt.year,
                          response.msgs![i].createdAt.month,
                          response.msgs![i].createdAt.day),
                      isSentByMe: response.msgs![i].byMe,
                      time:
                          "${response.msgs![i].createdAt.hour}:${response.msgs![i].createdAt.minute}",
                      seenStatus: response.msgs![i].status,
                      selectedImage: null,
                    ),
                  )
                },
              if (mounted)
                {
                  setState(() {}),
                }
            }
        });
  }

  void connect() {
    socket = IO.io("http://192.168.2.106:4000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    var params = {
      "token": widget.token,
      "chatId": widget.id,
    };
    socket.emit("viewChat", params);
    socket.on(
        "getMessage",
        (msg) => {
              setMessages(msg["text"], msg["date"], msg["time"], msg["status"])
            });
  }

  void setMessages(String text, String date, String time, String status) {
    if (mounted) {
      setState(() {
        messages.add(
          Message(
            text: text,
            date: DateTime.parse(date),
            isSentByMe: false,
            time: time,
            seenStatus: status,
            selectedImage: null,
          ),
        );
      });
    }
  }

  void sendMessage(
    String message,
    String date,
    String time,
  ) {
    var messagepar = {
      "text": message,
      "date": date,
      "time": time,
    };
    var params = {
      "token": widget.token,
      "message": messagepar,
      "members": [widget.member1!, widget.member2!]
    };
    socket.emit("sendMessage", params);
  }

  @override
  void initState() {
    if (mounted) {
      super.initState();
      connect();
      getMessages();
    }
  }

  @override
  void dispose() {
    var params = {"token": widget.token};
    socket.emit("leaveChat", params);
    super.dispose();
  }

  File? pickedimage;
  final ImagePicker picker = ImagePicker();
  late bool imageAccepted;
  Future takePhoto() async {
    var pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile!.path.endsWith("jpg")) {
      imageAccepted = true;
    } else if (pickedFile.path.endsWith("jpeg")) {
      imageAccepted = true;
    } else {
      imageAccepted = false;
    }
    if (imageAccepted) {
      if (mounted) {
        setState(() {
          pickedimage = File(pickedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorPalette.backgroundcolor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              WidgetsModels.Container_widget(
                null,
                100.h,
                Alignment.center,
                null,
                BoxDecoration(color: ColorPalette.Primary_Color_Original),
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 25, right: 25).w,
                      child: GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Icon(
                          Icons.arrow_back_rounded,
                          size: 30.sp,
                          color: ColorPalette.SH_Grey100,
                        ),
                      ),
                    ),
                    WidgetsModels.Container_widget(
                        45.w,
                        45.h,
                        Alignment.topLeft,
                        null,
                        BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(widget.image!),
                                fit: BoxFit.cover)),
                        null),
                    WidgetsModels.Container_widget(
                      220.w,
                      65.h,
                      Alignment.centerLeft,
                      const EdgeInsets.only(left: 15).w,
                      null,
                      Text(
                        widget.name!,
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              WidgetsModels.Container_widget(
                270.w,
                70.h,
                Alignment.center,
                const EdgeInsets.symmetric(horizontal: 25, vertical: 30).w,
                BoxDecoration(
                    color: ColorPalette.Primary_Color_Original,
                    borderRadius: BorderRadius.circular(4).r),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15).w,
                      child: Icon(FluentIcons.lock_shield_16_regular,
                          color: ColorPalette.SH_Grey100),
                    ),
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Text(
                        "Messages and calls are secure & encrypted. Screenshots will be disabled during this chat.",
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400),
                      ),
                    )),
                  ],
                ),
              ),
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: GroupedListView<Message, DateTime>(
                    elements: messages,
                    reverse: true,
                    order: GroupedListOrder.DESC,
                    groupBy: (message) => DateTime(
                      message.date.year,
                      message.date.month,
                      message.date.day,
                    ),
                    groupHeaderBuilder: (Message message) =>
                        WidgetsModels.Container_widget(
                      80.w,
                      50.h,
                      Alignment.center,
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                          .w,
                      BoxDecoration(borderRadius: BorderRadius.circular(4).r),
                      Card(
                        color: ColorPalette.Primary_Color_Original,
                        child: Padding(
                          padding: const EdgeInsets.all(12).w,
                          child: Text(
                            DateFormat.yMMMd().format(message.date),
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                    itemBuilder: (context, Message message) => Align(
                        alignment: message.isSentByMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: message.isSentByMe
                            ? Container(
                                margin: const EdgeInsets.only(
                                        bottom: 10, top: 10, right: 5, left: 10)
                                    .w,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: const Radius.circular(8).r,
                                        bottomRight: const Radius.circular(8).r,
                                        topLeft: const Radius.circular(8).r),
                                    color: ColorPalette.Primary_Color_Dark),
                                child: Stack(
                                  children: [
                                    if (message.time == "now")
                                      if (message.selectedImage == null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                                  right: 75,
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 10)
                                              .w,
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: 150.w,
                                                  minWidth: 50.w),
                                              child: Text(
                                                message.text,
                                                style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              )),
                                        )
                                      else
                                        Padding(
                                          padding: const EdgeInsets.only(
                                                  right: 65,
                                                  top: 10,
                                                  bottom: 10,
                                                  left: 20)
                                              .w,
                                          child: ConstrainedBox(
                                              constraints: BoxConstraints(
                                                  maxWidth: 150.w,
                                                  minWidth: 50.w),
                                              child: Image(
                                                image: pickedimage
                                                    as ImageProvider,
                                              )),
                                        )
                                    else
                                      Padding(
                                        padding: const EdgeInsets.only(
                                                right: 100,
                                                top: 10,
                                                bottom: 10,
                                                left: 10)
                                            .w,
                                        child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: 150.w,
                                                minWidth: 50.w),
                                            child: Text(
                                              message.text,
                                              style: GoogleFonts.montserrat(
                                                  color:
                                                      ColorPalette.SH_Grey100,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ),
                                    Positioned(
                                      bottom: 5,
                                      right: 5,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 10,
                                        ).w,
                                        child: Row(
                                          children: [
                                            Text(
                                              message.time,
                                              style: GoogleFonts.montserrat(
                                                  color:
                                                      ColorPalette.SH_Grey100,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                            if (message.seenStatus == "notSend")
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                        bottom: 2, left: 2)
                                                    .w,
                                                child: Icon(
                                                  FluentIcons.clock_12_regular,
                                                  color:
                                                      ColorPalette.SH_Grey300,
                                                  size: 12.sp,
                                                ),
                                              )
                                            else if (message.seenStatus ==
                                                "not seen")
                                              Icon(
                                                FluentIcons
                                                    .checkmark_12_regular,
                                                color: ColorPalette.SH_Grey300,
                                                size: 14.sp,
                                              )
                                            else
                                              Icon(
                                                FluentIcons
                                                    .checkmark_12_regular,
                                                color: ColorPalette
                                                    .Secondary_Color_Orignal,
                                                size: 14.sp,
                                              ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxWidth: 400.w, minWidth: 50.w),
                                child: Row(
                                  children: [
                                    WidgetsModels.Container_widget(
                                        32.w,
                                        32.h,
                                        Alignment.topCenter,
                                        const EdgeInsets.only(
                                                left: 10, bottom: 20)
                                            .w,
                                        BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image:
                                                    NetworkImage(widget.image!),
                                                fit: BoxFit.cover)),
                                        null),
                                    Container(
                                      margin: const EdgeInsets.only(
                                              bottom: 5, top: 5, left: 5)
                                          .w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                                  bottomLeft:
                                                      const Radius.circular(8)
                                                          .r,
                                                  bottomRight:
                                                      const Radius.circular(8)
                                                          .r,
                                                  topRight:
                                                      const Radius.circular(8))
                                              .r,
                                          color:
                                              ColorPalette.Primary_Color_Light),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                    right: 70,
                                                    top: 10,
                                                    bottom: 10,
                                                    left: 10)
                                                .w,
                                            child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: 150.w,
                                                    minWidth: 50.w),
                                                child: Text(
                                                  message.text,
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ),
                                          Positioned(
                                            bottom: 5,
                                            right: 10,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                top: 10,
                                              ).w,
                                              child: Text(
                                                message.time,
                                                style: GoogleFonts.montserrat(
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                    fontSize: 10.sp,
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                  ),
                ),
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
                          hintText: "Message",
                          contentPadding: const EdgeInsets.only(
                                  left: 28, top: 7, right: 12, bottom: 10)
                              .w,
                          suffixIcon: filled
                              ? GestureDetector(
                                  child:
                                      const Icon(FluentIcons.send_16_regular),
                                  onTap: () {
                                    Message message = Message(
                                      text: _controllerTF.text,
                                      date: DateTime.now()
                                          .subtract(const Duration(minutes: 0)),
                                      isSentByMe: true,
                                      time: "now",
                                      seenStatus: "notSend",
                                      selectedImage: null,
                                    );
                                    setStateTF(() {
                                      _controllerTF.text = "";
                                      numLines = 1;
                                      filled = false;
                                    });
                                    setState(() {
                                      if (message.text.isNotEmpty &&
                                          RegExp(r'[A-Za-z0-9_.\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=]')
                                              .hasMatch(message.text)) {
                                        messages.add(message);
                                      }
                                    });
                                    SendMessageRequestModel requestModel =
                                        SendMessageRequestModel(
                                            chatId: widget.id!,
                                            text: message.text);
                                    String hour;
                                    String minutes;
                                    APISERVICES()
                                        .sendMessage(requestModel)
                                        .then((response) => {
                                              if (response.createdAt.hour < 10)
                                                {
                                                  hour =
                                                      "0${response.createdAt.hour}",
                                                }
                                              else
                                                {
                                                  hour =
                                                      "${response.createdAt.hour}",
                                                },
                                              if (response.createdAt.minute <
                                                  10)
                                                {
                                                  minutes =
                                                      "0${response.createdAt.minute}",
                                                }
                                              else
                                                {
                                                  minutes =
                                                      "${response.createdAt.minute}",
                                                },
                                              message = Message(
                                                text: response.text,
                                                date: DateTime(
                                                    response.createdAt.year,
                                                    response.createdAt.month,
                                                    response.createdAt.day),
                                                isSentByMe: true,
                                                time: "$hour:$minutes",
                                                seenStatus: response.status,
                                                selectedImage: null,
                                              ),
                                              sendMessage(
                                                  response.text,
                                                  response.createdAt
                                                      .toIso8601String(),
                                                  "$hour:$minutes"),
                                              socket.emit("isInChat", {
                                                "token": widget.token,
                                                "members": [
                                                  widget.member1,
                                                  widget.member2
                                                ],
                                                "chatId": widget.id
                                              }),
                                              socket.on(
                                                  "isInChatResponse",
                                                  (isInChat) async => {
                                                        if (isInChat)
                                                          {
                                                            message.seenStatus =
                                                                "seen",
                                                            APISERVICES()
                                                                .updateMessage(
                                                                    response
                                                                        .id),
                                                          },
                                                        if (mounted)
                                                          {
                                                            setState(() {
                                                              messages[messages
                                                                      .length -
                                                                  1] = message;
                                                            }),
                                                          }
                                                      }),
                                            });
                                  },
                                )
                              : GestureDetector(
                                  onTap: () async {
                                    final message = Message(
                                        text: "",
                                        date: DateTime.now(),
                                        isSentByMe: true,
                                        time: "now",
                                        seenStatus: "send",
                                        selectedImage: null);
                                    await takePhoto().then((value) => {
                                          message.selectedImage =
                                              pickedimage as ImageProvider,
                                        });
                                    if (mounted) {
                                      setState(() {
                                        if (message.text.isNotEmpty ||
                                            pickedimage != null) {
                                          messages.add(message);
                                        }
                                      });
                                    }
                                  },
                                  child: Icon(
                                    FluentIcons.camera_16_regular,
                                    color: ColorPalette.SH_Grey900,
                                    size: 24,
                                  ),
                                ),
                          suffixIconColor: ColorPalette.SH_Grey900,
                          suffixStyle:
                              const TextStyle(fontWeight: FontWeight.w900),
                          focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide.none)),
                    ),
                  ),
                );
              }),
            ]),
      ),
    );
  }
}
