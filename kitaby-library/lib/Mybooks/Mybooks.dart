import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Mybooks/Addbook.dart';
import 'package:kitabylib/Mybooks/Upload_A_File.dart';
import 'package:kitabylib/models/api_services.dart';
import 'package:kitabylib/models/getBooksresponsemodel.dart';
import 'package:kitabylib/models/getavailablebooksmodel.dart';

class Mybooks extends StatefulWidget{
  const Mybooks({super.key});

  @override
  State<StatefulWidget> createState()  => MybooksState();
}


class MybooksState extends State<StatefulWidget>{

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
      _mediaQueryHeight = mediaQueryData.size.height;
    });
    }
  }


  static List<Book> booksfound=[];
  
  bool hasmore =true;
  int page =1;
  bool isloading=false;
  // ignore: non_constant_identifier_names
  final _list_offers_controller=ScrollController(); 

  Future fetchoffers(String name) async{
    if(isloading)return;
    isloading=true;
    Getavailablebooksresponsemodel? response= await APISERVICES().getAvalaibleBooks( page,name);///get loan books
    if(response!=null ){
      if(mounted){
        setState(() {
          page++;
          isloading=false;
          if( response.availableBooks.length<8){hasmore=false;}
          if(response.total>booksfound.length){booksfound.addAll(response.availableBooks);}
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
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Container(
          height: _mediaQueryWidth/11,
          color: Colors.white,
          child:Padding(
            padding: EdgeInsets.all(_mediaQueryWidth/50).w,
            child: WidgetsModels.searchbar(_searchcontroller,275.w,"Search",//prefix
            GestureDetector(//set shared preferences
              onTap: (){
                search(_searchcontroller.value.text);
              },
              child: Icon(FluentIcons.search_20_regular,color: ColorPalette.SH_Grey900,)),
              null,
              (p0) => search(p0),
            ),
          )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: _mediaQueryWidth/11.h,
                child: Padding(
                  padding: EdgeInsets.all(_mediaQueryWidth/40).w,
                  child: Text(
                    'Available Books',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: _mediaQueryWidth/40.sp,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(_mediaQueryWidth/60).w,
                    child: GestureDetector(
                       onTap:()async{
                        showDialog(
                        context: context,
                        builder:(context) => UploadFile(),//doesn't work rn
                        ).whenComplete(() => refresh());;
                        },
                      child: WidgetsModels.button1(_mediaQueryWidth*(9/75).w,_mediaQueryWidth*(9/320).h,ColorPalette.SH_Grey100,FluentIcons.send_copy_20_filled,ColorPalette.Primary_Color_Original,'Upload A File',shadow: true)),
                  ),
                  Padding(
                    padding:EdgeInsets.all(_mediaQueryWidth/60).w,
                    child: GestureDetector(
                      onTap:()async{
                        showDialog(
                        context: context,
                        builder:(context) => const Addbook(),//doesn't work rn
                        ).whenComplete(() => refresh());
                        },
                      child: WidgetsModels.button1(_mediaQueryWidth*(9/75).w,_mediaQueryWidth*(9/320).h,ColorPalette.Primary_Color_Original,FluentIcons.add_20_filled,ColorPalette.SH_Grey100,'Add A Book',shadow: true)),
                  ), 
                ],
              )
            ],
          ),
          StatefulBuilder(
            builder: (context,setStatelist) {
              return RefreshIndicator(
                onRefresh: refresh,
                child: SizedBox(
                  width: _mediaQueryWidth.w,
                  height:(_mediaQueryHeight-_mediaQueryWidth*(2/11)).h,//calculated
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: _list_offers_controller,
                    scrollDirection: Axis.vertical,
                    itemCount:(booksfound.length/4).ceil()+1,
                    itemBuilder: (context, i) {
                      return  Row( 
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if(i*4<booksfound.length)  
                            WidgetsModels.bookcard(booksfound[i*4].title, _mediaQueryWidth/60,booksfound[i*4].author, _mediaQueryWidth/70, ColorPalette.SH_Grey900,booksfound[i*4].image, _mediaQueryWidth/8,_mediaQueryWidth/3, _mediaQueryWidth/8, _mediaQueryWidth/5,false,"quantity",quantity: booksfound[i*4].quantity),                         
                          if(i*4+1<booksfound.length)  
                            WidgetsModels.bookcard(booksfound[i*4+1].title, _mediaQueryWidth/60,booksfound[i*4+1].author, _mediaQueryWidth/70, ColorPalette.SH_Grey900,booksfound[i*4+1].image, _mediaQueryWidth/8,_mediaQueryWidth/3, _mediaQueryWidth/8, _mediaQueryWidth/5,false,"quantity",quantity: booksfound[i*4+1].quantity),
                          if(i*4+2<booksfound.length)  
                            WidgetsModels.bookcard(booksfound[i*4+2].title, _mediaQueryWidth/60,booksfound[i*4+2].author, _mediaQueryWidth/70, ColorPalette.SH_Grey900,booksfound[i*4+2].image, _mediaQueryWidth/8,_mediaQueryWidth/3, _mediaQueryWidth/8, _mediaQueryWidth/5,false,"quantity",quantity: booksfound[i*4+2].quantity),
                          if(i*4+3<booksfound.length) 
                            WidgetsModels.bookcard(booksfound[i*4+3].title, _mediaQueryWidth/60,booksfound[i*4+3].author, _mediaQueryWidth/70, ColorPalette.SH_Grey900,booksfound[i*4+3].image, _mediaQueryWidth/8,_mediaQueryWidth/3, _mediaQueryWidth/8, _mediaQueryWidth/5,false,"quantity",quantity: booksfound[i*4+3].quantity),
                          if(i*4+1==booksfound.length+1)
                            Center(child:isloading
                            ?const CircularProgressIndicator()
                            : Center(
                              child: Text(
                                'No More Books',
                                style: GoogleFonts.montserrat(
                                  color: ColorPalette.SH_Grey900,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                              ),
                            )),
                            ],);    
                          },),),
                      );
                    }
                  )
        ],
      ),

    );
    }
  }