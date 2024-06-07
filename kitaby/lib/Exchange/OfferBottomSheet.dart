// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/getBooksresponsemodel.dart';
import 'package:kitaby/models/get_collection_responsemodel.dart';

class OfferBottomSheet extends StatefulWidget {
  final AllBook? bookwanted;

  const OfferBottomSheet({
    super.key,
    required this.bookwanted,
  });

  @override
  // ignore: library_private_types_in_public_api
  _OfferBottomSheetState createState() => _OfferBottomSheetState();
}

class _OfferBottomSheetState extends State<OfferBottomSheet> {
  static List<BooksList> my_books = [];
  static List<String> my_booksisbn = [];

  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  final _list_offers_controller = ScrollController();

  Future fetchoffers() async {
    if (isloading) return;
    isloading = true;
    Getcollectionresponsemodel? response =
        await APISERVICES().getCollection(page);
    if (mounted) {
      setState(() {
        page++;
        isloading = false;
        if (response.booksList.length < 8) {
          hasmore = false;
        }
        if (my_books.length < response.total) {
          my_books.addAll(response.booksList);
        }
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

  List<BooksList> booksselected = [];

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
              child: SizedBox(
                  child: Text(
                'Offer',
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 24,
                    fontWeight: FontWeight.w600),
              )),
            ),
            Row(
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Owner :',
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.SH_Grey100,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  (widget.bookwanted!.owner.length > 23)
                      ? ("${widget.bookwanted!.owner.substring(0, 22)}...")
                      : widget.bookwanted!.owner,
                  style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                      12,
                      widget.bookwanted!.author,
                      8,
                      ColorPalette.SH_Grey100,
                      widget.bookwanted!.image,
                      100,
                      null,
                      100,
                      140,
                      false,
                      'wishlist')),
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Text(
                'My Books',
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 210,
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                controller: _list_offers_controller,
                itemCount: my_books.length + 1,
                itemBuilder: (context, i) {
                  if (i < my_books.length) {
                    return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: GestureDetector(
                          onTap: () {
                            if (booksselected.contains(my_books[i])) {
                              setState(() {
                                booksselected.remove(my_books[i]);
                              });
                            } else {
                              setState(() {
                                booksselected.add(my_books[i]);
                              });
                            }
                          },
                          child: WidgetsModels.bookcard(
                              my_books[i].title,
                              12,
                              my_books[i].author,
                              8,
                              ColorPalette.SH_Grey100,
                              my_books[i].image,
                              100,
                              null,
                              100,
                              140,
                              booksselected.contains(my_books[i]),
                              "mybooks"),
                        ));
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Center(
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
                                )),
                    );
                  }
                },
              ),
            ),
            if (booksselected.isNotEmpty)
              GestureDetector(
                  onTap: () async {
                    my_booksisbn.clear();
                    for (BooksList e in booksselected) {
                      my_booksisbn.add(e.isbn);
                    }
                    await APISERVICES().PostOffer(my_booksisbn,
                        widget.bookwanted!.isbn, widget.bookwanted!.ownerId);
                    context.pop();
                  },
                  child: WidgetsModels.Container_widget(
                    null,
                    45,
                    Alignment.center,
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 25),
                    BoxDecoration(
                      color: ColorPalette.SH_Grey100,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    Text(
                      'Send Offer',
                      style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey900,
                          fontSize: 22,
                          fontWeight: FontWeight.w700),
                    ),
                  ))
            else
              WidgetsModels.Container_widget(
                null,
                45,
                Alignment.center,
                const EdgeInsets.symmetric(horizontal: 70, vertical: 25),
                BoxDecoration(
                  color: ColorPalette.SH_Grey300,
                  borderRadius: BorderRadius.circular(5),
                ),
                Text(
                  'Send Offer',
                  style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: 22,
                      fontWeight: FontWeight.w700),
                ),
              )
          ],
        ),
      ),
    );
  }
}
