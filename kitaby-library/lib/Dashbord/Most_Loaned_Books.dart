import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/bar_graph_data.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/graph_model.dart';
import 'package:kitabylib/main.dart';

class Most_Loaned_Books extends StatefulWidget{
  const Most_Loaned_Books({super.key});

  @override
  State<StatefulWidget> createState()  => Most_Loaned_BooksState();
}


class Most_Loaned_BooksState extends State<StatefulWidget>{

 double _mediaQueryWidth = 0.0;
 double _mediaQueryHeight = 0.0;



 
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call updateMediaQuerySize in didChangeDependencies
    updateMediaQuerySize();
  }

  void updateMediaQuerySize() {
    setState(() {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      _mediaQueryWidth = mediaQueryData.size.width*(5/6)*(1/2);
      _mediaQueryHeight = mediaQueryData.size.width*(5/6)*(1/2);
     
     print(_mediaQueryWidth);
    });
  }

  List<Map> Books =[
   {
    "title":"Pride and Prejudice",
    "author":"jane austen",
    "image":"http://books.google.com/books/content?id=XfFvDwAAQBAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
   },
   {
    "title":"Pride",
    "author":"ibi zoboi",
    "image":"http://books.google.com/books/content?id=U8RuwwEACAAJ&printsec=frontcover&img=1&zoom=1&source=gbs_api"
   },
   {
    "title":"To Kill a Mockingbird",
    "author":"harper lee",
    "image":"http://books.google.com/books/content?id=ncuX8p2xLIUC&printsec=frontcover&img=1&zoom=1&source=gbs_api"
   }
  ];

  int pos=0;


  @override
  Widget build(BuildContext context) {
  
    
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white
        ),
        child: Padding(
          padding:EdgeInsets.all(15) ,
          child: Stack(

            alignment: Alignment.center,
            children: [



              

              Positioned(
                    left: 0,
                    top:  0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Most Loaned Books',
                        style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey900,
                              fontSize: _mediaQueryWidth/20,
                              fontWeight: FontWeight.w500
                            ),
                      ),
                    ),
                  ),

              Positioned(
                bottom: 0,
                child: Container(
                  width: _mediaQueryWidth-60,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if(pos!=0 ){
                              pos--;
                            }else {
                              pos=Books.length-1;
                            }
                          });
                        },
                        child: Icon(FluentIcons.chevron_left_12_filled),
                       ),
                      WidgetsModels.bookcard(Books[pos]["title"],_mediaQueryWidth/20,Books[pos]["author"],_mediaQueryWidth/25,ColorPalette.SH_Grey900,Books[pos]["image"],_mediaQueryWidth/3,_mediaQueryWidth*(2/3),_mediaQueryWidth/4,_mediaQueryWidth*(2/5),false,null ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if( pos!=Books.length-1){
                              pos++;
                            }else{
                              pos=0;
                            }
                          });
                        },
                        child: Icon(FluentIcons.chevron_right_12_filled),
                       ),
                   
                    ],
                  ),
                ),
              )

            ],
          ),
           ),
      ),
    );
    }
}