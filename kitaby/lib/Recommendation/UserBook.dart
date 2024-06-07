// ignore_for_file: file_names, non_constant_identifier_names, use_build_context_synchronously
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:kitaby/models/config.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/countDown.dart';
import 'package:kitaby/models/Recommendation/addRating_request_model.dart';
import 'package:kitaby/models/Recommendation/getBook_response_model.dart';
import 'package:kitaby/models/Recommendation/getRatings_response_model.dart';
import 'package:kitaby/models/api_services.dart';
import 'package:kitaby/models/profile/get_post_response_model.dart';

class UserBook extends StatefulWidget {
  final String? id;
  const UserBook({super.key, required this.id});

  @override
  State<UserBook> createState() => _UserBookState();
}

class _UserBookState extends State<UserBook> {
  bool loading = true;
  late String type = "";
  late double RatingBooks;
  late DateTime date;
  late String status;
  late bool aE;
  bool valide = true;
  late bool aL;
  late GetbookResponseModel book;
  late List<Rating> reviews = [];
  bool hasmore = true;
  int page = 1;
  bool isloading = false;
  bool isStreched = true;
  double nr = 0.0;
  final ScrollController _list_rating_controller = ScrollController();
  final TextEditingController _content_controller = TextEditingController();

  Future refresh() async {
    setState(() {
      isloading = false;
      hasmore = true;
      page = 1;
      reviews.clear();
    });
    fetchrecomondations();
  }

  void setTypeId(String type1, String id1, int level1) {}

  Future fetchrecomondations() async {
    if (isloading) return;
    isloading = true;
    GetRatingsResponseModel responsebody =
        await APISERVICES().getRatings(widget.id!, page);
    setState(() {
      page++;
      isloading = false;
      if (responsebody.ratings.length < 6) {
        hasmore = false;
      }
      reviews.addAll(responsebody.ratings);
    });
  }

  @override
  void initState() {
    APISERVICES().isBookAvailable(widget.id!).then((response2) => {
          setState(() {
            aE = response2.isAvailableExchange;
            aL = response2.isAvailableLoan;
          }),
        });
    APISERVICES().getRating(widget.id!).then((response2) => {
          setState(() {
            RatingBooks = response2.averageRating;
          }),
        });
    APISERVICES().isBookOwned(widget.id!).then((response2) => {
          setState(() {
            if (response2.collection) {
              type = "mybooks";
            } else if (response2.wishlist) {
              type = "wishlist";
            } else if (response2.reservation.exists) {
              type = "loan";
              status = response2.reservation.status;
            } else {
              type = "fffff";
            }
          }),
        });
    APISERVICES().getBookInfo(widget.id!).then((response) => {
          setState(() {
            fetchrecomondations();
            book = response;
            loading = false;
          }),
        });
    _list_rating_controller.addListener(() {
      if (_list_rating_controller.position.maxScrollExtent ==
          _list_rating_controller.offset) {
        fetchrecomondations();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorPalette.backgroundcolor,
        child: Column(
          children: [
            WidgetsModels.title(context),
            if (loading)
              Container(
                margin: const EdgeInsets.only(top: 30).w,
                child: CircularProgressIndicator(
                  color: ColorPalette.Primary_Color_Light,
                ),
              )
            else
              Expanded(
                child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (overScroll) {
                    overScroll.disallowIndicator();
                    return true;
                  },
                  child: ListView(
                    children: [
                      WidgetsModels.bookcard(
                          book.title,
                          16.sp,
                          book.author,
                          12.sp,
                          ColorPalette.SH_Grey100,
                          book.image,
                          150.w,
                          null,
                          133.w,
                          210.h,
                          false,
                          type),
                      Center(
                        child: WidgetsModels.Container_widget(
                          null,
                          95.h,
                          Alignment.center,
                          const EdgeInsets.only(bottom: 10, right: 19).w,
                          null,
                          Container(
                            margin: const EdgeInsets.all(17).w,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Rating : ",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    WidgetsModels.rating(
                                        18.sp, RatingBooks, true, 1.3.w, nr)
                                  ],
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Genre : ",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      book.categories[0].length > 25
                                          ? "${book.categories[0].substring(0, 25)}..."
                                          : book.categories[0],
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey100,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (type == "mybooks")
                        if (valide)
                          WidgetsModels.Container_widget(
                              90.w,
                              20.h,
                              Alignment.center,
                              const EdgeInsets.only(
                                      bottom: 30, right: 20, left: 20)
                                  .w,
                              null,
                              Text(
                                "Available",
                                style: GoogleFonts.montserrat(
                                    color: ColorPalette.Secondary_Color_Orignal,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w500),
                              ))
                        else
                          WidgetsModels.Container_widget(
                              200.w,
                              20.h,
                              Alignment.center,
                              const EdgeInsets.only(bottom: 30, right: 19).w,
                              null,
                              Text(
                                "Not Available",
                                style: GoogleFonts.montserrat(
                                    color: ColorPalette.Error,
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w500),
                              ))
                      else if (type == "loan")
                        Column(
                          children: [
                            WidgetsModels.Container_widget(
                                300.w,
                                35.h,
                                null,
                                const EdgeInsets.only(bottom: 30).w,
                                null,
                                countDown(
                                    fontWeight: FontWeight.w600,
                                    color: ColorPalette.Error,
                                    fontSize: 18.sp,
                                    deadline: DateTime.now()
                                        .add(const Duration(days: 10)))),
                            GestureDetector(
                              onTap: () {},
                              child: WidgetsModels.Container_widget(
                                  160.w,
                                  35.h,
                                  Alignment.center,
                                  const EdgeInsets.only(right: 19).w,
                                  BoxDecoration(
                                    color: ColorPalette.SH_Grey100,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  Text("Return to Library",
                                      style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey900,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w700))),
                            ),
                          ],
                        )
                      else if (valide)
                        Column(
                          children: [
                            WidgetsModels.Container_widget(
                                90.w,
                                20.h,
                                Alignment.center,
                                const EdgeInsets.only(
                                        bottom: 30, right: 20, left: 20)
                                    .w,
                                null,
                                Text(
                                  "Available",
                                  style: GoogleFonts.montserrat(
                                      color:
                                          ColorPalette.Secondary_Color_Orignal,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                              margin: const EdgeInsets.only(right: 19).w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: WidgetsModels.Container_widget(
                                          160.w,
                                          35.h,
                                          Alignment.center,
                                          const EdgeInsets.only(
                                                  left: 20, right: 20)
                                              .w,
                                          BoxDecoration(
                                            color: ColorPalette.SH_Grey100,
                                            borderRadius:
                                                BorderRadius.circular(5).r,
                                          ),
                                          Text("Loan From Library",
                                              style: GoogleFonts.montserrat(
                                                  color:
                                                      ColorPalette.SH_Grey900,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                    ),
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: WidgetsModels.Container_widget(
                                          160.w,
                                          35.h,
                                          Alignment.center,
                                          const EdgeInsets.only(left: 20).w,
                                          BoxDecoration(
                                            color: ColorPalette.SH_Grey100,
                                            borderRadius:
                                                BorderRadius.circular(5).r,
                                          ),
                                          Text("Exchange with users",
                                              style: GoogleFonts.montserrat(
                                                  color:
                                                      ColorPalette.SH_Grey900,
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      FontWeight.w700))),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            WidgetsModels.Container_widget(
                                200.w,
                                20.h,
                                Alignment.center,
                                const EdgeInsets.only(bottom: 30, right: 19).w,
                                null,
                                Text(
                                  "Not Available",
                                  style: GoogleFonts.montserrat(
                                      color: ColorPalette.Error,
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w500),
                                )),
                            Container(
                              margin: const EdgeInsets.only(right: 19).w,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: WidgetsModels.Container_widget(
                                        160.w,
                                        35.h,
                                        Alignment.center,
                                        const EdgeInsets.only(left: 20).w,
                                        BoxDecoration(
                                          color: ColorPalette.SH_Grey500,
                                          borderRadius:
                                              BorderRadius.circular(5).r,
                                        ),
                                        Text("Loan From Library",
                                            style: GoogleFonts.montserrat(
                                                color: ColorPalette.SH_Grey900,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700))),
                                  ),
                                  Expanded(
                                    child: WidgetsModels.Container_widget(
                                        160.w,
                                        35.h,
                                        Alignment.center,
                                        const EdgeInsets.only(left: 20).w,
                                        BoxDecoration(
                                          color: ColorPalette.SH_Grey500,
                                          borderRadius:
                                              BorderRadius.circular(5).r,
                                        ),
                                        Text("Exchange with users",
                                            style: GoogleFonts.montserrat(
                                                color: ColorPalette.SH_Grey900,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w700))),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      WidgetsModels.Container_widget(
                          142.w,
                          30.w,
                          null,
                          const EdgeInsets.only(top: 26, bottom: 10, left: 20)
                              .w,
                          null,
                          Text(
                            "Description",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500),
                          )),
                      WidgetsModels.Container_widget(
                          null,
                          null,
                          null,
                          const EdgeInsets.only(left: 20, right: 19).w,
                          null,
                          Text(
                            "",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400),
                          )),
                      WidgetsModels.Container_widget(
                          142.w,
                          30.w,
                          null,
                          const EdgeInsets.only(left: 20, top: 25, bottom: 25)
                              .w,
                          null,
                          Text(
                            "Reviews",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500),
                          )),
                      WidgetsModels.Container_widget(
                        350.w,
                        400.h,
                        null,
                        const EdgeInsets.only(left: 20, right: 5).w,
                        null,
                        Stack(
                          children: [
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
                                          controller: _list_rating_controller,
                                          itemCount: reviews.length + 1,
                                          itemBuilder: (context, i) {
                                            if (i < reviews.length) {
                                              return WidgetsModels
                                                  .Container_widget(
                                                50.w,
                                                null,
                                                Alignment.topLeft,
                                                const EdgeInsets.only(
                                                        bottom: 30)
                                                    .w,
                                                BoxDecoration(
                                                    color:
                                                        ColorPalette.SH_Grey100,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                                10)
                                                            .r),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(20)
                                                          .w,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          WidgetsModels.Container_widget(
                                                              54.w,
                                                              54.h,
                                                              Alignment.topLeft,
                                                              const EdgeInsets
                                                                      .only(
                                                                      left: 19,
                                                                      right: 10,
                                                                      bottom:
                                                                          10,
                                                                      top: 11.5)
                                                                  .w,
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  image: DecorationImage(
                                                                      image: NetworkImage(
                                                                          "${config.http}/${reviews[i].pp}"),
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
                                                                              bottom: 5,
                                                                              left: 4)
                                                                          .w,
                                                                      null,
                                                                      Text(
                                                                        reviews[i]
                                                                            .review
                                                                            .username,
                                                                        style: GoogleFonts.montserrat(
                                                                            color:
                                                                                ColorPalette.SH_Grey900,
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                      )),
                                                              WidgetsModels.rating(
                                                                  18.sp,
                                                                  reviews[i]
                                                                          .review
                                                                          .rating +
                                                                      0.0,
                                                                  true,
                                                                  1.3.w,
                                                                  nr),
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                      WidgetsModels
                                                          .Container_widget(
                                                              null,
                                                              null,
                                                              null,
                                                              const EdgeInsets
                                                                      .only(
                                                                      left: 85,
                                                                      right: 10,
                                                                      bottom:
                                                                          8.5)
                                                                  .w,
                                                              null,
                                                              Text(
                                                                reviews[i]
                                                                    .review
                                                                    .comment,
                                                                style: GoogleFonts.montserrat(
                                                                    color: ColorPalette
                                                                        .SH_Grey900,
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ))
                                                    ],
                                                  ),
                                                ),
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
                                                            'No More Ratings',
                                                            style: GoogleFonts.montserrat(
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
                                    margin: const EdgeInsets.only(
                                            top: 150, left: 180)
                                        .w,
                                    width: 150.w,
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
                                              content: StatefulBuilder(builder:
                                                  (context, setDialog) {
                                                return Container(
                                                  margin: const EdgeInsets.only(
                                                          bottom: 10)
                                                      .w,
                                                  child: Column(
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
                                                                            fontSize: 14.sp,
                                                                            fontWeight: FontWeight.w600),
                                                                      )),
                                                              Container(
                                                                margin: const EdgeInsets
                                                                        .only(
                                                                        top: 5,
                                                                        left:
                                                                            10,
                                                                        right:
                                                                            20)
                                                                    .w,
                                                                child: Row(
                                                                  children: [
                                                                    Text(
                                                                        "Your rate : ",
                                                                        style: GoogleFonts.montserrat(
                                                                            fontSize:
                                                                                14.sp,
                                                                            fontWeight: FontWeight.w500,
                                                                            color: ColorPalette.SH_Grey900)),
                                                                    RatingBar.builder(
                                                                        itemSize: 14.sp,
                                                                        allowHalfRating: true,
                                                                        minRating: 0,
                                                                        initialRating: 0,
                                                                        ignoreGestures: false,
                                                                        itemPadding: const EdgeInsets.symmetric(horizontal: 1.3).w,
                                                                        itemBuilder: (context, index) {
                                                                          return Icon(
                                                                              FluentIcons.star_24_filled,
                                                                              color: ColorPalette.Star);
                                                                        },
                                                                        onRatingUpdate: (rating) {
                                                                          setState(
                                                                              () {
                                                                            nr =
                                                                                rating;
                                                                          });
                                                                        }),
                                                                  ],
                                                                ),
                                                              ),
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
                                                              "Enter your review here you only have 60 words !",
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
                                                                          AddRatingRequestModel rating = AddRatingRequestModel(
                                                                              isbn: widget.id!,
                                                                              rating: nr,
                                                                              comment: _content_controller.value.text);
                                                                          await APISERVICES().addRating(rating).then((response) =>
                                                                              {
                                                                                setStatebtn(() {
                                                                                  isStreched = true;
                                                                                }),
                                                                                if (response.message == "Rating added successfully!")
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
                                                                      child: isStreched ? WidgetsModels.button1(120, 30, ColorPalette.Secondary_Color_Orignal, FluentIcons.arrow_clockwise_dashes_16_regular, ColorPalette.SH_Grey100, "Post") : WidgetsModels.buildSmallGreenButton())),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
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
                                          "Add a rating",
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
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
