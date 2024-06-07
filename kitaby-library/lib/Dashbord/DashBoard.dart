import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/Books_Details_graph.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Dashbord/Loan_Details.dart';
import 'package:kitabylib/Dashbord/Most_Loaned_Books.dart';
import 'package:kitabylib/Dashbord/Readers_graph.dart';
import 'package:kitabylib/Dashbord/Statcards.dart';
import 'package:kitabylib/main.dart';

class DashBoard extends StatefulWidget{
  const DashBoard({super.key});

  @override
  State<StatefulWidget> createState()  => DashBoardState();
}


class DashBoardState extends State<StatefulWidget>{

 double _mediaQueryWidth = 0.0;
 double _mediaQueryHeight = 0.0;




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




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.verylightgrey,
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: EdgeInsets.all(_mediaQueryWidth/40),
            child: Text(
              'Dashboard',
              style: GoogleFonts.montserrat(
                color: ColorPalette.SH_Grey900,
                fontSize: _mediaQueryWidth/40,
                fontWeight: FontWeight.w500
              ),
            ),
          ),

           SizedBox(
            height: _mediaQueryWidth/4*(3/4),
            child: Statcards()),

            SizedBox(
            height: _mediaQueryWidth/2*(3/4),
            child: Books_Details_graph()),

            SizedBox(
            height: _mediaQueryWidth*(7/10),
            child: Loan_Details()),

            SizedBox(
            height: _mediaQueryWidth/2,
            child: Row(
              children: [
                Expanded(child: Readers_graph()),
                Expanded(child: Most_Loaned_Books())
              ],
            )),

        ],
      ),

    );
    }
  }