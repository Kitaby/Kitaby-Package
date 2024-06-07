// ignore_for_file: non_constant_identifier_names, file_names
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/countDown.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Reservation/cancelRservation_request_model.dart';
import 'package:kitaby/models/Reservation/getReservations_response_model.dart';
import 'package:kitaby/models/api_services.dart';

class LoanTimeLine extends StatefulWidget {
  const LoanTimeLine({super.key});
  @override
  State<LoanTimeLine> createState() => _LoanTimeLineState();
}

class _LoanTimeLineState extends State<LoanTimeLine> {
  List<R> reservations = [];
  List<bool> isStrecheds = [];
  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_recomondations_controller = ScrollController();
  FocusNode focus = FocusNode();
  bool searchfocus = false;
  bool seeall = false;
  Future fetchReservations() async {
    if (isloading) return;
    isloading = true;
    await APISERVICES().getReservations(page).then((response) => {
          if (response.rs != null)
            {
              setState(() {
                page++;
                isloading = false;
                if (response.rs!.length < 8) {
                  hasmore = false;
                }
                reservations.addAll(response.rs!);
                isStrecheds.addAll(List<bool>.generate(
                    response.rs!.length, (counter) => true));
              }),
            }
        });
  }

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 1;
      reservations.clear();
      isStrecheds.clear();
    });
    fetchReservations();
  }

  @override
  void initState() {
    super.initState();
    fetchReservations();
    _list_recomondations_controller.addListener(() {
      if (_list_recomondations_controller.position.maxScrollExtent ==
          _list_recomondations_controller.offset) {
        fetchReservations();
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
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: RefreshIndicator(
                      onRefresh: refresh,
                      color: ColorPalette.Primary_Color_Light,
                      backgroundColor: ColorPalette.SH_Grey100,
                      child: ListView.builder(
                        controller: _list_recomondations_controller,
                        scrollDirection: Axis.vertical,
                        itemCount: reservations.length + 1,
                        itemBuilder: (context, index) {
                          if (index < reservations.length) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 25),
                                  child: Row(
                                    children: [
                                      WidgetsModels.bookcard(
                                          reservations[index].bookName,
                                          10,
                                          reservations[index].author,
                                          8,
                                          ColorPalette.SH_Grey100,
                                          reservations[index].bookImage,
                                          64,
                                          250,
                                          150,
                                          95,
                                          false,
                                          ""),
                                      Expanded(
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          child: Column(
                                            children: [
                                              WidgetsModels.Container_widget(
                                                130,
                                                19,
                                                Alignment.topCenter,
                                                const EdgeInsets.only(
                                                    bottom: 15),
                                                null,
                                                Text(
                                                  reservations[index].bibName,
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                              WidgetsModels.Container_widget(
                                                300,
                                                15,
                                                Alignment.centerLeft,
                                                const EdgeInsets.only(
                                                    bottom: 15,
                                                    top: 5,
                                                    right: 30,
                                                    left: 10),
                                                null,
                                                Text(
                                                  "PeriodType : ${reservations[index].status} ",
                                                  style: GoogleFonts.montserrat(
                                                      color: ColorPalette
                                                          .SH_Grey100,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                              WidgetsModels.Container_widget(
                                                  300,
                                                  35,
                                                  null,
                                                  const EdgeInsets.only(
                                                      bottom: 30, left: 10),
                                                  null,
                                                  countDown(
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                    deadline: reservations[index]
                                                                    .status ==
                                                                "requested" ||
                                                            reservations[index]
                                                                    .status ==
                                                                "on hold"
                                                        ? reservations[index]
                                                            .date
                                                            .add(const Duration(
                                                                days: 3))
                                                        : reservations[index].status ==
                                                                "reserved"
                                                            ? reservations[index]
                                                                .date
                                                                .add(const Duration(
                                                                    days: 15))
                                                            : reservations[index]
                                                                .date
                                                                .add(const Duration(
                                                                    days: 3)),
                                                    fontSize: 12,
                                                  )),
                                              if (reservations[index].status ==
                                                      "on hold" ||
                                                  reservations[index].status ==
                                                      "requested")
                                                StatefulBuilder(builder:
                                                    (contextbtn, setStatebtn) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        setStatebtn(() {
                                                          isStrecheds[index] =
                                                              false;
                                                        });
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        CancelReservationRequestModel
                                                            thread =
                                                            CancelReservationRequestModel(
                                                                reservationId:
                                                                    reservations[
                                                                            index]
                                                                        .id);
                                                        await APISERVICES()
                                                            .cancelReservation(
                                                                thread)
                                                            .then(
                                                                (response) => {
                                                                      setStatebtn(
                                                                          () {
                                                                        isStrecheds[index] =
                                                                            true;
                                                                      }),
                                                                      if (response
                                                                              .message ==
                                                                          "deleted")
                                                                        {
                                                                          refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
                                                                              "success",
                                                                              "Canceling successed",
                                                                              "Your reservation has been cancelled"))),
                                                                        }
                                                                      else
                                                                        {
                                                                          refresh()
                                                                              .then(
                                                                            (value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
                                                                                "fail",
                                                                                "Unkwon error",
                                                                                "Please retry later")),
                                                                          ),
                                                                        }
                                                                    });
                                                      },
                                                      child: GestureDetector(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: isStrecheds[
                                                                      index]
                                                                  ? WidgetsModels.button1(
                                                                      90,
                                                                      30,
                                                                      ColorPalette
                                                                          .Error,
                                                                      FluentIcons
                                                                          .calendar_cancel_16_filled,
                                                                      ColorPalette
                                                                          .SH_Grey100,
                                                                      "Cancel Loan")
                                                                  : WidgetsModels
                                                                      .buildSmallRedButton())));
                                                })
                                              else if (reservations[index]
                                                      .status ==
                                                  "reserved")
                                                StatefulBuilder(builder:
                                                    (contextbtn, setStatebtn) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        setStatebtn(() {
                                                          isStrecheds[index] =
                                                              false;
                                                        });
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        CancelReservationRequestModel
                                                            thread =
                                                            CancelReservationRequestModel(
                                                                reservationId:
                                                                    reservations[
                                                                            index]
                                                                        .id);
                                                        await APISERVICES()
                                                            .ReturnBook(thread)
                                                            .then(
                                                                (response) => {
                                                                      setStatebtn(
                                                                          () {
                                                                        isStrecheds[index] =
                                                                            true;
                                                                      }),
                                                                      if (response
                                                                              .message ==
                                                                          "deleted")
                                                                        {
                                                                          refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
                                                                              "success",
                                                                              "Return successed",
                                                                              "Your return request was sent"))),
                                                                        }
                                                                      else
                                                                        {
                                                                          refresh()
                                                                              .then(
                                                                            (value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
                                                                                "fail",
                                                                                "Unkwon error",
                                                                                "Please retry later")),
                                                                          ),
                                                                        }
                                                                    });
                                                      },
                                                      child: GestureDetector(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: isStrecheds[
                                                                      index]
                                                                  ? WidgetsModels.button1(
                                                                      90,
                                                                      30,
                                                                      ColorPalette
                                                                          .SH_Grey100,
                                                                      FluentIcons
                                                                          .arrow_forward_16_regular,
                                                                      ColorPalette
                                                                          .SH_Grey900,
                                                                      "Return Book")
                                                                  : WidgetsModels
                                                                      .buildSmallWhiteButton())));
                                                })
                                              else
                                                StatefulBuilder(builder:
                                                    (contextbtn, setStatebtn) {
                                                  return GestureDetector(
                                                      onTap: () async {
                                                        setStatebtn(() {
                                                          isStrecheds[index] =
                                                              false;
                                                        });
                                                        await Future.delayed(
                                                            const Duration(
                                                                seconds: 1));
                                                        CancelReservationRequestModel
                                                            thread =
                                                            CancelReservationRequestModel(
                                                                reservationId:
                                                                    reservations[
                                                                            index]
                                                                        .id);
                                                        await APISERVICES()
                                                            .renewRequest(
                                                                thread)
                                                            .then(
                                                                (response) => {
                                                                      setStatebtn(
                                                                          () {
                                                                        isStrecheds[index] =
                                                                            true;
                                                                      }),
                                                                      if (response
                                                                              .r !=
                                                                          null)
                                                                        {
                                                                          refresh().then((value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
                                                                              "success",
                                                                              "Renew Sended",
                                                                              "Your renew request was sent"))),
                                                                        }
                                                                      else
                                                                        {
                                                                          refresh()
                                                                              .then(
                                                                            (value) => ScaffoldMessenger.of(context).showSnackBar(WidgetsModels.Dialog_Message(
                                                                                "fail",
                                                                                "Unkwon error",
                                                                                "Please retry later")),
                                                                          ),
                                                                        }
                                                                    });
                                                      },
                                                      child: GestureDetector(
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: isStrecheds[
                                                                      index]
                                                                  ? WidgetsModels.button1(
                                                                      90,
                                                                      30,
                                                                      ColorPalette
                                                                          .Secondary_Color_Orignal,
                                                                      FluentIcons
                                                                          .arrow_clockwise_dashes_16_regular,
                                                                      ColorPalette
                                                                          .SH_Grey100,
                                                                      "Renew Loan")
                                                                  : WidgetsModels
                                                                      .buildSmallGreenButton2())));
                                                })
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                WidgetsModels.Container_widget(
                                    null,
                                    1,
                                    null,
                                    const EdgeInsets.symmetric(vertical: 20),
                                    BoxDecoration(
                                        color: ColorPalette.SH_Grey100),
                                    null),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Center(
                                  child: hasmore
                                      ? CircularProgressIndicator(
                                          color:
                                              ColorPalette.Primary_Color_Light,
                                        )
                                      : Text(
                                          'No More Reservations',
                                          style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey100,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        )),
                            );
                          }
                        },
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
