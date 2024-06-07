// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/Reservation/getLibsBooks_response_model.dart';
import 'package:kitaby/models/Reservation/request_book_request_model.dart';
import 'package:kitaby/models/api_services.dart';

class LoanBottomSheet extends StatefulWidget {
  final AllBook? bookwanted;

  const LoanBottomSheet({
    super.key,
    required this.bookwanted,
  });

  @override
  // ignore: library_private_types_in_public_api
  _LoanBottomSheetState createState() => _LoanBottomSheetState();
}

class _LoanBottomSheetState extends State<LoanBottomSheet> {
  late List mybooks;
  bool isStreched = true;
  List<bool> isselected = [];
  List<String> booksselected = [];

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (overscroll) {
        overscroll.disallowIndicator();
        return true;
      },
      child: SizedBox(
        height: MediaQuery.sizeOf(context).height - 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 40,
              margin: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                      height: 30,
                      child: Text(
                        'Loan',
                        style: GoogleFonts.montserrat(
                            color: ColorPalette.SH_Grey100,
                            fontSize: 24,
                            fontWeight: FontWeight.w600),
                      )),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text(
                    'The Library Owner :',
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey100,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  (widget.bookwanted!.bib.length > 23)
                      ? ("${widget.bookwanted!.bib.substring(0, 22)}...")
                      : widget.bookwanted!.bib,
                  style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.all(20),
              child: Text(
                'The book Wanted :',
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.pushNamed(RoutesName.UserBook,
                    pathParameters: {"isbn": widget.bookwanted!.isbn});
              },
              child: Container(
                  child: WidgetsModels.bookcard(
                      widget.bookwanted!.title,
                      14,
                      widget.bookwanted!.author,
                      10,
                      ColorPalette.SH_Grey100,
                      widget.bookwanted!.image,
                      115,
                      null,
                      115,
                      180,
                      false,
                      '')),
            ),
            StatefulBuilder(
                builder: (contextbtn, setStatebtn) => GestureDetector(
                    onTap: () async {
                      setStatebtn(() {
                        isStreched = false;
                      });
                      RequestbookRequestModel reservation =
                          RequestbookRequestModel(
                              bibId: widget.bookwanted!.bibId,
                              bookIsbn: widget.bookwanted!.isbn);
                      await Future.delayed(const Duration(seconds: 1));
                      await APISERVICES()
                          .requestBook(reservation)
                          .then((response) => {
                                setStatebtn(() {
                                  isStreched = true;
                                }),
                                // if (response.message == "success")
                                //   {
                                context.pop(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                    WidgetsModels.Dialog_Message(
                                        "success",
                                        "Book rquested",
                                        "Your rquest was sent successfuly wait for the bib to accept")),
                                // }
                                // else if (response.message == "Not verified")
                                //   {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //         WidgetsModels.Dialog_Message(
                                //             "help",
                                //             response.message,
                                //             "Please verify your email to use Kitaby")),
                                //   }
                                // else if (response.message == "Wrong Credentials")
                                //   {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //         WidgetsModels.Dialog_Message(
                                //             "fail",
                                //             response.message,
                                //             "Your email or password was incorrect please retry")),
                                //   }
                                // else
                                //   {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //         WidgetsModels.Dialog_Message("fail",
                                //             "Unkwon error", "Please retry later")),
                                //   }
                              });
                    },
                    child: isStreched
                        ? WidgetsModels.Container_widget(
                            null,
                            50,
                            Alignment.center,
                            const EdgeInsets.all(25),
                            BoxDecoration(
                              color: ColorPalette.SH_Grey100,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            Text(
                              "Request Book",
                              style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey900,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        : WidgetsModels.buildSmallButton()))
          ],
        ),
      ),
    );
  }
}
