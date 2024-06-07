import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/bar_graph_data.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/graph_model.dart';
import 'package:kitabylib/main.dart';

class Readers_graph extends StatefulWidget{
  const Readers_graph({super.key});

  @override
  State<StatefulWidget> createState()  => Readers_graphState();
}


class Readers_graphState extends State<StatefulWidget>{

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



              Padding(
                padding:  EdgeInsets.only(bottom: (_mediaQueryHeight/7)-30),
                child: PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: _mediaQueryHeight/5,
                    startDegreeOffset: -90,
                     sections: [
                
                      PieChartSectionData(
                        color: ColorPalette.Primary_Color_Light,
                        value: 40,
                        showTitle: false,
                        radius: _mediaQueryHeight/30,
                      ),
                      
                      PieChartSectionData(
                        color: ColorPalette.SH_Grey300,
                        value: 20,
                        showTitle: false,
                        radius: _mediaQueryHeight/30,
                      
                      ),
                
                     ],
                  )
                ),
              ),

              Positioned(
                    left: 0,
                    top:  0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Readers',
                        style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey900,
                              fontSize: _mediaQueryWidth/20,
                              fontWeight: FontWeight.w500
                            ),
                      ),
                    ),
                  ),

              Positioned(
                
                bottom: (_mediaQueryHeight/10)-30,
                child:Container(
                  width: _mediaQueryWidth-60,
                  child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                    children: [

                      Column(
                        
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '20',
                              style: GoogleFonts.montserrat(
                                    color: ColorPalette.SH_Grey900,
                                    fontSize: _mediaQueryWidth/20,
                                    fontWeight: FontWeight.w700
                                  ),
                            ),
                          ),

                          Row(
                            children: [
                              Container(
                                height:_mediaQueryHeight/30 ,
                                width:_mediaQueryHeight/30 ,
                                decoration: BoxDecoration(
                                  color: ColorPalette.SH_Grey300,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'Repeated',
                                  style: GoogleFonts.montserrat(
                                        color: ColorPalette.SH_Grey900,
                                        fontSize: _mediaQueryWidth/20,
                                        fontWeight: FontWeight.w500
                                      ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                  
                  
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '40',
                              style: GoogleFonts.montserrat(
                                    color: ColorPalette.SH_Grey900,
                                    fontSize: _mediaQueryWidth/20,
                                    fontWeight: FontWeight.w700
                                  ),
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                height:_mediaQueryHeight/30 ,
                                width:_mediaQueryHeight/30 ,
                                decoration: BoxDecoration(
                                  color: ColorPalette.Primary_Color_Light,
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  'New Readers',
                                  style: GoogleFonts.montserrat(
                                        color: ColorPalette.SH_Grey900,
                                        fontSize: _mediaQueryWidth/20,
                                        fontWeight: FontWeight.w500
                                      ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                  
                    ],
                  ),
                ) ,
              )


            ],
          ),
           ),
      ),
    );
    }
}