import 'dart:async';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:kitabylib/Login.dart';
import 'package:kitabylib/Mainscreen.dart';
import 'package:kitabylib/models/api_services.dart';

class SideBarMenu extends StatefulWidget{
  const SideBarMenu({super.key});

  @override
  State<StatefulWidget> createState()  => SideBarMenuState();
}


class SideBarMenuState extends State<StatefulWidget>{

 double _mediaQueryWidth = 0.0;
 double _mediaQueryHeight = 0.0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call updateMediaQuerySize in didChangeDependencies
    updateMediaQuerySize();
  }

  void updateMediaQuerySize() {
    setState(() {
      MediaQueryData mediaQueryData = MediaQuery.of(context);
      _mediaQueryWidth = mediaQueryData.size.width/6;
      _mediaQueryHeight = mediaQueryData.size.height;
    });
  }


  static int selected = 0;

   

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:const BoxDecoration(
        color: Colors.white 
      ),
      child: ListView(
       
       children: [

        Padding(
          padding:const EdgeInsets.symmetric(vertical: 15),
          child:SizedBox(height: _mediaQueryWidth/2,width:_mediaQueryWidth/2,child: Image.asset(Path.Logolib),),
        ),

        GestureDetector(
          onTap: () {
            setState(() {
            selected=0;
            MainscreenState.currentscreen.value=0;
          });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius:const BorderRadius.all(Radius.circular(10)),
              color:(selected==0)? ColorPalette.Primary_Color_Light:Colors.white
            ),
            height:_mediaQueryWidth/4,
            margin:const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Padding(
                  padding:  EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
                  child: Icon((selected!=0)?Icons.insert_chart_outlined_rounded:Icons.insert_chart_rounded,size:_mediaQueryWidth/9,color:(selected==0)? Colors.white:ColorPalette.SH_Grey900, ),
                ),
                Text(
                  'Dashboard',
                  style: GoogleFonts.montserrat(
                    color: (selected==0)? Colors.white:ColorPalette.SH_Grey900,
                    fontSize: _mediaQueryWidth/16,
                    fontWeight: FontWeight.w500
                  ),
                )
              ],
            ),
          ),
        ),
        GestureDetector(
         onTap: () {
           setState(() {
             selected=1;
             MainscreenState.currentscreen.value=1;
           });
         },
         child: Container(
           decoration: BoxDecoration(
             borderRadius:const BorderRadius.all(Radius.circular(10)),
             color: (selected==1)? ColorPalette.Primary_Color_Light:Colors.white
           ),
            height:_mediaQueryWidth/4,
            margin:const EdgeInsets.symmetric(horizontal: 15),
           child: Row(
            
            children: [
             Padding(
               padding: EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
               child: Icon((selected!=1)?FluentIcons.book_24_regular:FluentIcons.book_24_filled,size:_mediaQueryWidth/9,color: (selected==1)? Colors.white:ColorPalette.SH_Grey900, ),
             ),
             Text(
               'Available Books',
               style: GoogleFonts.montserrat(
                 color: (selected==1)? Colors.white:ColorPalette.SH_Grey900, 
                 fontSize: _mediaQueryWidth/16,
                 fontWeight: FontWeight.w500
               ),
             )
           ],),
         ),
        ),
        GestureDetector(
        onTap: () {
          setState(() {
            selected=2;
            MainscreenState.currentscreen.value=2;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            color: (selected==2)? ColorPalette.Primary_Color_Light:Colors.white
          ),
           height:_mediaQueryWidth/4,
           margin:const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
           
           children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
              child: Icon((selected!=2)?FluentIcons.book_clock_24_regular:FluentIcons.book_clock_24_filled,size:_mediaQueryWidth/9,color:(selected==2)? Colors.white:ColorPalette.SH_Grey900,  ),
            ),
            Text(
              'Loan Requests',
              style: GoogleFonts.montserrat(
                color: (selected==2)? Colors.white:ColorPalette.SH_Grey900, 
                fontSize: _mediaQueryWidth/16,
                fontWeight: FontWeight.w500
              ),
            )
          ],),
        ),
                 ),
       
        GestureDetector(
        onTap: () {
          setState(() {
            selected=3;
            MainscreenState.currentscreen.value=3;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            color: (selected==3)? ColorPalette.Primary_Color_Light:Colors.white
          ),
           height:_mediaQueryWidth/4,
           margin:const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
           
           children: [
            Padding(
              padding:EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
              child: Icon((selected!=3)?FluentIcons.book_question_mark_24_regular:FluentIcons.book_question_mark_24_filled,size:_mediaQueryWidth/9,color: (selected==3)? Colors.white:ColorPalette.SH_Grey900,  ),
            ),
            Text(
              'Pending Books',
              style: GoogleFonts.montserrat(
                color: (selected==3)? Colors.white:ColorPalette.SH_Grey900, 
                fontSize: _mediaQueryWidth/16,
                fontWeight: FontWeight.w500
              ),
            )
          ],),
        ),
                 ),
         
        GestureDetector(
        onTap: () {
          setState(() {
            selected=4;
            MainscreenState.currentscreen.value=4;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius:const BorderRadius.all(Radius.circular(10)),
            color:(selected==4)? ColorPalette.Primary_Color_Light:Colors.white
          ),
           height:_mediaQueryWidth/4,
          margin:const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
           
           children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
              child: Icon((selected!=4)?FluentIcons.book_exclamation_mark_24_regular:FluentIcons.book_exclamation_mark_24_filled,size:_mediaQueryWidth/9,color:(selected==4)? Colors.white:ColorPalette.SH_Grey900,  ),
            ),
            Text(
              'Books On Loan',
              style: GoogleFonts.montserrat(
                color: (selected==4)? Colors.white:ColorPalette.SH_Grey900, 
                fontSize: _mediaQueryWidth/16,
                fontWeight: FontWeight.w500
              ),
            )
          ],),
        ),
        ),
         GestureDetector(
         onTap: () {
           setState(() {
             selected=5;
             MainscreenState.currentscreen.value=5;
           });
         },
         child: Container(
           decoration: BoxDecoration(
             borderRadius:const BorderRadius.all(Radius.circular(10)),
             color: (selected==5)? ColorPalette.Primary_Color_Light:Colors.white
           ),
            height:_mediaQueryWidth/4,
            margin:const EdgeInsets.symmetric(horizontal: 15),
           child: Row(
           
            children: [
             
             Padding(
               padding: EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
               child: Icon((selected!=5)?FluentIcons.book_pulse_24_regular:FluentIcons.book_pulse_24_filled,size:_mediaQueryWidth/9,color: (selected==5)? Colors.white:ColorPalette.SH_Grey900,  ),
             ),
             Text(
               'Expired Books',
               style: GoogleFonts.montserrat(
                 color: (selected==5)? Colors.white:ColorPalette.SH_Grey900, 
                 fontSize: _mediaQueryWidth/16,
                 fontWeight: FontWeight.w500
               ),
             )
           ],),
         ),
        ),
        GestureDetector(
         onTap: () {
           setState(() {
             selected=6;
             MainscreenState.currentscreen.value=6;
           });
         },
         child: Container(
           decoration: BoxDecoration(
             borderRadius:const BorderRadius.all(Radius.circular(10)),
             color: (selected==6)? ColorPalette.Primary_Color_Light:Colors.white
           ),
            height:_mediaQueryWidth/4,
            margin:const EdgeInsets.symmetric(horizontal: 15),
           child: Row(
           
            children: [
             
             Padding(
               padding: EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
               child: Icon((selected!=6)?FluentIcons.book_clock_24_regular:FluentIcons.book_clock_24_filled,size:_mediaQueryWidth/9,color: (selected==6)? Colors.white:ColorPalette.SH_Grey900,  ),
             ),
             Text(
               'Renew Requests',
               style: GoogleFonts.montserrat(
                 color: (selected==6)? Colors.white:ColorPalette.SH_Grey900, 
                 fontSize: _mediaQueryWidth/16,
                 fontWeight: FontWeight.w500
               ),
             )
           ],),
         ),
        ),
         Padding(
           padding:const EdgeInsets.symmetric(vertical: 10),
           child: Container(height: 0.5,color:ColorPalette.SH_Grey300 ,),
         ),

          GestureDetector(
          onTap: () {
            setToken("");
            Timer(const Duration(seconds: 2), () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>const Login(),), (route) => false);
            });
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius:const BorderRadius.all(Radius.circular(10)),
              color: ColorPalette.Error,
            ),
             height:_mediaQueryWidth/4,
             margin:const EdgeInsets.symmetric(horizontal: 15),
            child: Row(         
             children: [
              Padding(
                padding:EdgeInsets.symmetric(horizontal:_mediaQueryWidth/20),
                child: Icon(FluentIcons.power_24_regular,size:_mediaQueryWidth/9,color:  Colors.white,),
              ),
              Text(
                'Logout',
                style: GoogleFonts.montserrat(
                  color: Colors.white, 
                  fontSize: _mediaQueryWidth/16,
                  fontWeight: FontWeight.w500
                ),
              )
            ],),
          ),
          ),

      ],),
    );
  }
  
}