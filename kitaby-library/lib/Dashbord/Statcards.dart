// ignore_for_file: sort_child_properties_last

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/main.dart';

class Statcards extends StatefulWidget{
  const Statcards({super.key});

  @override
  State<StatefulWidget> createState()  => StatcardsState();
}


class StatcardsState extends State<StatefulWidget>{

 double _mediaQueryWidth = 0.0;
 double _mediaQueryHeight = 0.0;



 late double screenWidth;
  late double screenHeight;

  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call updateMediaQuerySize in didChangeDependencies
    updateMediaQuerySize();
  }

  void updateMediaQuerySize() {
    setState(() {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      _mediaQueryWidth = mediaQueryData.size.width*5/6;
      _mediaQueryHeight = mediaQueryData.size.width*(5/6)*(3/4)*(1/4);
   
    });
  }


  List<Map> cardstonk =[
    {
      "rate":2.5,
      "sense":"down",
    },
    {
      "rate":1.5,
      "sense":"up",
    },
    {
      "rate":1.8,
      "sense":"up",
    },
    {
      "rate":0.4,
      "sense":"down",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        
        children: [


 //total users
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.all(15),
             
              child: Stack(
                children: [

                  Positioned(
                    child: Container(
                      height:_mediaQueryHeight/4 ,
                      width: _mediaQueryHeight/4,
                      decoration: BoxDecoration(
                        color: ColorPalette.violet.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(_mediaQueryHeight/(5*10)),
                      child: Icon(FluentIcons.people_16_filled,color: ColorPalette.violet,size: _mediaQueryHeight/6)),
                  top: _mediaQueryHeight/15,
                  right:_mediaQueryHeight/15 ,
                  ),

                  Positioned(
                    child: Text(
                    'Total User',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey500,
                      fontSize: _mediaQueryWidth/50*(20/35),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  top: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  ),
              
                  Positioned(
                    child: Text(
                    '13',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: _mediaQueryWidth/50,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  top: _mediaQueryHeight/2 * (3/4),
                  left:_mediaQueryHeight/15 ,
                  ),
              
                  Positioned(
                    
                    child: (cardstonk[0]["sense"]=="up")?
                    Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_20_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Secondary_Color_Orignal,),
                        Text(
                        '${cardstonk[0]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Secondary_Color_Orignal,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % Up from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    )
                    :
                     Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_down_24_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Error,),
                        Text(
                        '${cardstonk[0]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Error,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % down from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    ),
                  bottom: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  )
                  
                ],
              ),
            )
            ),

  //total books  
         Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.all(15),
             
              child: Stack(
                children: [

                  Positioned(
                    child: Container(
                      height:_mediaQueryHeight/4 ,
                      width: _mediaQueryHeight/4,
                      decoration: BoxDecoration(
                        color: ColorPalette.Secondary_Color_Orignal.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(_mediaQueryHeight/(5*10)),
                      child: Icon(FluentIcons.book_16_filled,color: ColorPalette.Secondary_Color_Orignal,size: _mediaQueryHeight/6)),
                  top: _mediaQueryHeight/15,
                  right:_mediaQueryHeight/15 ,
                  ),

                  Positioned(
                    child: Text(
                    'Total Books',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey500,
                      fontSize: _mediaQueryWidth/50*(20/35),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  top: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  ),
              
                  Positioned(
                    child: Text(
                    '39',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: _mediaQueryWidth/50,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  top: _mediaQueryHeight/2 * (3/4),
                  left:_mediaQueryHeight/15 ,
                  ),
              
               
                    Positioned(
                    
                    child: (cardstonk[1]["sense"]=="up")?
                    Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_20_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Secondary_Color_Orignal,),
                        Text(
                        '${cardstonk[1]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Secondary_Color_Orignal,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % Up from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    )
                    :
                     Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_down_24_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Error,),
                        Text(
                        '${cardstonk[1]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Error,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % down from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    ),
                  bottom: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  )
                  

                ],
              ),
            )
            ),

  //total order
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.all(15),
             
              child: Stack(
                children: [

                  Positioned(
                    child: Container(
                      height:_mediaQueryHeight/4 ,
                      width: _mediaQueryHeight/4,
                      decoration: BoxDecoration(
                        color:ColorPalette.Star.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(_mediaQueryHeight/(5*10)),
                      child: Icon(FluentIcons.cube_16_regular,color:ColorPalette.Star,size: _mediaQueryHeight/6)),
                  top: _mediaQueryHeight/15,
                  right:_mediaQueryHeight/15 ,
                  ),

                  Positioned(
                    child: Text(
                    'Total Order',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey500,
                      fontSize: _mediaQueryWidth/50*(20/35),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  top: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  ),
              
                  Positioned(
                    child: Text(
                    '8',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: _mediaQueryWidth/50,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  top: _mediaQueryHeight/2 * (3/4),
                  left:_mediaQueryHeight/15 ,
                  ),
              
                  Positioned(
                    
                    child: (cardstonk[2]["sense"]=="up")?
                    Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_20_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Secondary_Color_Orignal,),
                        Text(
                        '${cardstonk[2]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Secondary_Color_Orignal,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % Up from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    )
                    :
                     Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_down_24_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Error,),
                        Text(
                        '${cardstonk[2]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Error,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % down from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    ),
                  bottom: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  )
                  
                ],
              ),
            )
            ),



  //total pending
         Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              margin: EdgeInsets.all(15),
             
              child: Stack(
                children: [

                  Positioned(
                    child: Container(
                      height:_mediaQueryHeight/4 ,
                      width: _mediaQueryHeight/4,
                      decoration: BoxDecoration(
                        color: ColorPalette.salmon.withOpacity(0.4),
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      padding: EdgeInsets.all(_mediaQueryHeight/(5*10)),
                      child: Icon(FluentIcons.timer_16_regular,color: ColorPalette.salmon,size: _mediaQueryHeight/6)),
                  top: _mediaQueryHeight/15,
                  right:_mediaQueryHeight/15 ,
                  ),

                  Positioned(
                    child: Text(
                    'Total Pending',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey500,
                      fontSize: _mediaQueryWidth/50*(20/35),
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  top: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  ),
              
                  Positioned(
                    child: Text(
                    '7',
                    style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: _mediaQueryWidth/50,
                      fontWeight: FontWeight.w700
                    ),
                  ),
                  top: _mediaQueryHeight/2 * (3/4),
                  left:_mediaQueryHeight/15 ,
                  ),
              
                   Positioned(
                    
                    child: (cardstonk[3]["sense"]=="up")?
                    Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_20_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Secondary_Color_Orignal,),
                        Text(
                        '${cardstonk[3]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Secondary_Color_Orignal,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % Up from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    )
                    :
                     Row(
                      children: [
                        Icon(FluentIcons.arrow_trending_down_24_filled,size:_mediaQueryWidth/50*(20/35) ,color: ColorPalette.Error,),
                        Text(
                        '${cardstonk[3]["rate"]}',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.Error,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                        Text(
                        ' % down from yesterday',
                        style: GoogleFonts.montserrat(
                          color: ColorPalette.SH_Grey500,
                          fontSize: _mediaQueryWidth/50*(20/35),
                          fontWeight: FontWeight.w500
                        )),
                      ],
                    ),
                  bottom: _mediaQueryHeight/15,
                  left:_mediaQueryHeight/15 ,
                  )
                  
                ],
              ),
            )
            ),


        ],
      ),

    );
    }
  }