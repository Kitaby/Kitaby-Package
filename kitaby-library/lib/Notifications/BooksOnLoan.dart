import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/CountDown.dart';
import 'package:kitabylib/models/api_services.dart';
import 'package:kitabylib/models/getreservedBooksResponseModel.dart';

class BooksOnLoan extends StatefulWidget {
  const BooksOnLoan({super.key});

  @override
  State<BooksOnLoan> createState() => _BooksOnLoanState();
}

class _BooksOnLoanState extends State<BooksOnLoan> {
  double _mediaQueryWidth = 0.0;
  double _mediaQueryHeight = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call updateMediaQuerySize in didChangeDependencies
    updateMediaQuerySize();
  }

  void updateMediaQuerySize() {
    if(mounted){
    setState(() {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      _mediaQueryWidth = mediaQueryData.size.width*5/6;
      _mediaQueryHeight= mediaQueryData.size.height;
    });
  }}

   List<ReservedBook> booksfound=[];
  
  bool hasmore =true;
  int page =1;
  bool isloading=false;
  final _list_offers_controller=ScrollController(); 

  Future fetchoffers(String name) async{
    if(isloading)return;
    isloading=true;
    GetReservedBooksResponseModel? response= await APISERVICES().getReservedBooks( page,name);///get loan books
    if(response!=null ){
      if(mounted){
        setState(() {
          page++;
          isloading=false;
          if( response.reservedBooks
          .length<8){hasmore=false;}
          booksfound.addAll(response.reservedBooks);
            });
          }}
           
            }

  Future refresh()async{
    if(mounted){
    setState(() {
      seeall=false;
      isloading=false;
      hasmore=true;
      page=1;
      booksfound.clear();
      _searchcontroller.text="";
        });
    fetchoffers("");
  }}
  
  @override
  void initState() {
    super.initState();
    fetchoffers("");
   
    
    
    _list_offers_controller.addListener(() {
      if(_list_offers_controller.position.maxScrollExtent==_list_offers_controller.offset){
        print(page);
        fetchoffers(_searchcontroller.text);
        
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _list_offers_controller.dispose();
  }
 
void search(String e){
 if(mounted){
     setState(() {
       isloading=false;
      hasmore=true;
      page=1;
      booksfound.clear();
      seeall=false;
      fetchoffers(e);
    
     
     });
 } 
}
 
  FocusNode focus =FocusNode();
  final _searchcontroller = TextEditingController();
  bool searchfocus =false; 
  bool seeall =false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.verylightgrey,
      body: ListView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Container(height: _mediaQueryWidth/11.h,color: Colors.white,
          child:Padding(
            padding: EdgeInsets.all(_mediaQueryWidth/50).w,
            child: WidgetsModels.searchbar(_searchcontroller,275.w,"Search",//prefix
            GestureDetector(//set shared preferences
              onTap: (){
                search(_searchcontroller.value.text);
              },
              child: Icon(FluentIcons.search_20_regular,color: ColorPalette.SH_Grey900,)),//suffix
                      null,  //on submitted        
                      (p0) => search(p0),      
            ),
          )
          ),
          Container(
            height: _mediaQueryWidth/11,
            child: Padding(
              padding: EdgeInsets.all(_mediaQueryWidth/40).w,
              child: Text(
                'Books on Loan',
                style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey900,
                  fontSize: _mediaQueryWidth/40.sp,
                  fontWeight: FontWeight.w500
                ),
              ),
            ),
          ),
          StatefulBuilder(        
            builder: (context,setStatelist) {
              return RefreshIndicator(
                onRefresh: refresh,
                child: Container(
                  width: _mediaQueryWidth.w,
                  height:(_mediaQueryHeight-_mediaQueryWidth*(2/11)).h,//calculated
                  child: ListView.builder(
                    shrinkWrap: true,            
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: _list_offers_controller,
                    scrollDirection: Axis.vertical,
                    itemCount:booksfound.length+1,
                    itemBuilder: (context, i) {              
                      if(i<booksfound.length){
                        return Column(
                          children: [
                            Container(
                              height: _mediaQueryWidth*(1/4).h,
                              margin:const EdgeInsets.only(left: 45 ).w,
                              child:Row(
                                children: [
                                  WidgetsModels.bookcard(booksfound[i].bookName,_mediaQueryWidth/65.sp,booksfound[i].author,_mediaQueryWidth/80.sp,ColorPalette.SH_Grey900, booksfound[i].bookImage,_mediaQueryWidth/10.w,_mediaQueryWidth*(1/4).h,_mediaQueryWidth/10.w,_mediaQueryWidth*(1/8).h,false,null ),                                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        WidgetsModels.Container_widget(_mediaQueryWidth/2.w, _mediaQueryWidth*(1/20).h, Alignment.center,const EdgeInsets.only(bottom: 10 ), null,  Text(booksfound[i].reserverName, style: GoogleFonts.montserrat(color: ColorPalette.SH_Grey900 , fontSize: 25.sp , fontWeight: FontWeight.w600),),),
                                        WidgetsModels.Container_widget(_mediaQueryWidth/1.6.w,_mediaQueryWidth*(1/20).h, Alignment.topLeft,null, null, Text("PeriodType: Having the book" , style: GoogleFonts.montserrat(color: ColorPalette.SH_Grey900 , fontSize: 18.sp , fontWeight: FontWeight.w400),), ),
                                        WidgetsModels.Container_widget(_mediaQueryWidth/1.6.w,_mediaQueryWidth*(1/20).h, Alignment.topLeft, null,null,
                                        countDown(
                                          fontWeight: FontWeight.w400,
                                          color: ColorPalette.SH_Grey900,
                                          deadline: booksfound[i].date.add(
                                            Duration(days: 15)
                                          ),
                                          fontSize: 17.sp,
                                        )
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ), 
                            WidgetsModels.Container_widget(null, 1.h, null,const EdgeInsets.symmetric(vertical: 20).w, BoxDecoration(color: Color(0xffD8D8D8)), null),
                          ],
                        );
                      }
                      else{
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 32).w,
                          child: Center(child:hasmore
                          ?const CircularProgressIndicator()
                          : Text(
                            'No More Books',
                            style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey100,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500),
                            )
                          ),
                        );
                      }
                    },
                  ),
                ),
              );
            }
          )    
        ],
      ),
    );
  }
}