// ignore_for_file: non_constant_identifier_names, file_names
import 'package:kitaby/models/Reservation/getReservations_response_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';

class LoanBooks extends StatefulWidget {
  const LoanBooks({super.key});
  @override
  State<LoanBooks> createState() => LoanBooksstate();
}

class LoanBooksstate extends State<LoanBooks> {
  List<R> my_books = [];
  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_offers_controller = ScrollController();

  Future fetchoffers() async {
    if (isloading) return;
    isloading = true;
    GetReservationsResponseModel response =
        await APISERVICES().getReservations(page);
    // ignore: unnecessary_null_comparison
    if (response != null) {
      setState(() {
        page++;
        isloading = false;
        if (response.rs!.length < 8) {
          hasmore = false;
        }
        my_books.addAll(response.rs!);
      });
    }
  }

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 0;
      my_books.clear();
    });
    fetchoffers();
  }

  @override
  void initState() {
    super.initState();
    fetchoffers();

    _list_offers_controller.addListener(() {
      if (_list_offers_controller.position.maxScrollExtent ==
          _list_offers_controller.offset) {
        fetchoffers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _list_offers_controller.dispose();
  }

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.all(20),
                    child: Text(
                      "Loan Books",
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey100,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 700,
                child: RefreshIndicator(
                  onRefresh: refresh,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _list_offers_controller,
                    itemCount: (my_books.length % 2 == 0)
                        ? (my_books.length / 2 + 1).ceil()
                        : ((my_books.length + 1) / 2).ceil(),
                    itemBuilder: (context, i) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (i * 2 < my_books.length)
                            SizedBox(
                                height: 300,
                                width: 125,
                                child: WidgetsModels.bookcard(
                                    my_books[i * 2].bookName,
                                    14,
                                    my_books[i * 2].author,
                                    12,
                                    ColorPalette.SH_Grey100,
                                    my_books[i * 2].bookImage,
                                    115,
                                    null,
                                    115,
                                    180,
                                    false,
                                    "loan")),
                          if (i * 2 + 1 < my_books.length)
                            SizedBox(
                                height: 300,
                                width: 125,
                                child: WidgetsModels.bookcard(
                                    my_books[i * 2 + 1].bookName,
                                    14,
                                    my_books[i * 2 + 1].author,
                                    12,
                                    ColorPalette.SH_Grey100,
                                    my_books[i * 2 + 1].bookImage,
                                    115,
                                    null,
                                    115,
                                    180,
                                    false,
                                    "loan")),
                          if (i * 2 + 2 == my_books.length + 1)
                            Center(
                                child: hasmore
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'No More Books',
                                        style: GoogleFonts.montserrat(
                                            color: ColorPalette.SH_Grey100,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      )),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
