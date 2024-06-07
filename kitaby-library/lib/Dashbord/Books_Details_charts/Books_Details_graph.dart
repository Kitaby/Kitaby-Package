import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/bar_graph_data.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/graph_model.dart';
import 'package:kitabylib/main.dart';

class Books_Details_graph extends StatefulWidget{
  const Books_Details_graph({super.key});

  @override
  State<StatefulWidget> createState()  => Books_Details_graphState();
}


class Books_Details_graphState extends State<StatefulWidget>{

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
      _mediaQueryWidth = mediaQueryData.size.width*5/6;
      _mediaQueryHeight = mediaQueryData.size.width/2*(3/4)*(5/6);
     print(_mediaQueryWidth);
    });
  }




  @override
  Widget build(BuildContext context) {
    final barGraphData=BarGraphData();

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white
        ),
        child: Padding(
          padding:EdgeInsets.all(15) ,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: _mediaQueryWidth/20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        barGraphData.data.label,
                        style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey900,
                              fontSize: _mediaQueryWidth/50,
                              fontWeight: FontWeight.w500
                            ),
                      ),
                    ),
                  ),
                  Container(
                    height: _mediaQueryWidth/20,
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Last Month',
                        style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey900,
                              fontSize: _mediaQueryWidth/50,
                              fontWeight: FontWeight.w400
                            ),
                      ),
                    ),
                    ),
                  
                ],
              ),
      
              SizedBox(height:_mediaQueryWidth/40 ,),
      
              Expanded(
                child:  Stack(
                  children: [
                    BarChart(
                      
                      BarChartData(
                        
                        barGroups:_chartGroups(
                          points: barGraphData.data.graph,
                          color: barGraphData.data.color,
                        ),
                        borderData: FlBorderData(border: Border()),
                        gridData: FlGridData(show: false),
                        minY: 0,
                        maxY: 100,
                       
                                   
                        
                        titlesData: FlTitlesData(
                        show: true,  
                          
                          
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              
                              showTitles: true,
                              reservedSize: _mediaQueryWidth/30,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: EdgeInsets.only(top: _mediaQueryWidth/80),
                                  child:Text(
                                    barGraphData.label[value.toInt()],
                                    style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey900,
                                          fontSize: _mediaQueryWidth/80,// a changer
                                          fontWeight: FontWeight.w500
                                        ),
                                  ), 
                                );
                              },
                            )
                          ),
                          
                          
                          leftTitles: AxisTitles(
                            
                            sideTitles: SideTitles(
                              showTitles:true,
                              reservedSize:60, //
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return (barGraphData.lefttitle[value.toInt()] != null)
                                ? Text(
                                    barGraphData.lefttitle[value.toInt()].toString(),
                                    style: GoogleFonts.montserrat(
                                          color: ColorPalette.SH_Grey900,
                                          fontSize: _mediaQueryWidth/80,// a changer
                                          fontWeight: FontWeight.w500
                                        ),
                                  ):const SizedBox();
                              },
                              
                            )
                          ),
                    
                          
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false,)
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false)
                          ),
                          
                        ),
                       
                      ),
                       
                    ),

                    Container(
                      height: (_mediaQueryHeight-( _mediaQueryWidth*(13/120))-60),// calculated
                     // color: Colors.lightGreenAccent,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        Padding(
                          padding: const EdgeInsets.only(left:60),
                          child: Container(height: 1,color: ColorPalette.SH_Grey700.withOpacity(0.4),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:60),
                          child: Container(height: 1,color: ColorPalette.SH_Grey700.withOpacity(0.4),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:60),
                          child: Container(height: 1,color: ColorPalette.SH_Grey700.withOpacity(0.4),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:60),
                          child: Container(height: 1,color: ColorPalette.SH_Grey700.withOpacity(0.4),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:60),
                          child: Container(height: 1,color: ColorPalette.SH_Grey700.withOpacity(0.4),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:60),
                          child: Container(height: 1,color: ColorPalette.SH_Grey700.withOpacity(0.4),),
                        ),
                      ],),
                    )
                  ],
                ),

              )
            ],
          ),
        ),
      ),
    );
    }






    List<BarChartGroupData> _chartGroups(
      {required List<GraphModel> points,required Color color}
    ){
      return points
      .map((point) => BarChartGroupData(x: point.x.toInt(),barRods: [
        BarChartRodData( 
          toY: point.y,
          
          width: 15 ,// a changer
          color: color.withOpacity(point.y.toInt() > 80 ? 1 : point.y.toInt() > 60? 0.85: point.y.toInt() > 40? 0.75 : point.y.toInt() > 20? 0.65 :0.5),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(3),
            topRight: Radius.circular(3),
          )
        )
      ]))
      .toList();
    }
  }