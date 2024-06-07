import 'package:fl_chart/fl_chart.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/bar_graph_data.dart';
import 'package:kitabylib/Dashbord/Books_Details_charts/graph_model.dart';
import 'package:kitabylib/main.dart';

class Loan_Details extends StatefulWidget{
  const Loan_Details({super.key});

  @override
  State<StatefulWidget> createState()  => Loan_DetailsState();
}


class Loan_DetailsState extends State<StatefulWidget>{

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
      _mediaQueryWidth = mediaQueryData.size.width*(5/6);
      _mediaQueryHeight = mediaQueryData.size.width*(5/6)*(7/10);
     print(_mediaQueryWidth);
    });
  }


  List<String> loantype= [
    "rejected",
    "delivered",
    "pending",
    "returning",
    "rejected",
    "returning",
    "delivered",
    "rejected",
    "pending",
    "pending",
  ];

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
                        'Loan Details',
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
                    child: Padding(
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

              Container(
                margin: EdgeInsets.symmetric( vertical: 15),
                height:_mediaQueryWidth/20 ,
                decoration: BoxDecoration(
                  color: ColorPalette.verylightgrey,
                  borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child:Text(
                          'Book Name',
                          style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontSize: _mediaQueryWidth/60,
                                fontWeight: FontWeight.w600
                              ),
                        ) ,
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child:Text(
                          'User',
                          style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontSize: _mediaQueryWidth/60,
                                fontWeight: FontWeight.w600
                              ),
                        ) ,
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child:Text(
                          'Date - Time',
                          style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontSize: _mediaQueryWidth/60,
                                fontWeight: FontWeight.w600
                              ),
                        ) ,
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child:Text(
                          'Status',
                          style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey900,
                                fontSize: _mediaQueryWidth/60,
                                fontWeight: FontWeight.w600
                              ),
                        ) ,
                    ),

                  ],
                ),
              ),

              SizedBox(
                height: _mediaQueryHeight-(_mediaQueryWidth/8)-90,
                child: ListView.builder(
                  shrinkWrap: true,
                  
                  scrollDirection: Axis.vertical,
                  itemCount: 10,
                  itemBuilder:(context, index) {
                    return Column(
                      children: [
                        Container(
                          child:Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                        
                               Container(
                                padding: EdgeInsets.all(20),
                                 child: Row(
                                   children: [
                                 
                                     FadeInImage.assetNetwork(
                                      placeholder: Path.Logolib, // Before image load
                                      image: "http://books.google.com/books/content?id=ncuX8p2xLIUC&printsec=frontcover&img=1&zoom=1&source=gbs_api", // After image load
                                      width:_mediaQueryWidth/24,
                                      height: _mediaQueryWidth/14,
                                      fit: BoxFit.contain,),
                                 
                                     Padding(
                                       padding: const EdgeInsets.all(10.0),
                                       child: Text(
                                           'Book Name',
                                           style: GoogleFonts.montserrat(
                                                 color: ColorPalette.SH_Grey900,
                                                 fontSize: _mediaQueryWidth/60,
                                                 fontWeight: FontWeight.w600
                                               ),
                                         ),
                                     ),
                                   ],
                                 ),
                               ),
                        
                               Padding(
                                    padding: EdgeInsets.all(20),
                                    child:Text(
                                        'UserName',
                                        style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey900,
                                              fontSize: _mediaQueryWidth/60,
                                              fontWeight: FontWeight.w600
                                            ),
                                      ) ,
                                    ),
                        
                               Padding(
                                    padding: EdgeInsets.all(20),
                                    child:Text(
                                        'Date',
                                        style: GoogleFonts.montserrat(
                                              color: ColorPalette.SH_Grey900,
                                              fontSize: _mediaQueryWidth/60,
                                              fontWeight: FontWeight.w600
                                            ),
                                      ) ,
                                    ),
                        
                               Container(
                                height: _mediaQueryWidth/25,
                                decoration: BoxDecoration(
                                  color:(loantype[index]=="rejected")?ColorPalette.Error.withOpacity(0.7)
                                        :(loantype[index]=="delivered")?ColorPalette.Secondary_Color_Orignal
                                        :(loantype[index]=="pending")?ColorPalette.Star
                                        :ColorPalette.Primary_Color_Light,
                                  
                                  
                                  borderRadius: BorderRadius.all(Radius.circular(50))
                                ),
                                padding: EdgeInsets.all(_mediaQueryWidth/120),
                                child:Text(
                                        (loantype[index]=="rejected")?'rejected'
                                        :(loantype[index]=="delivered")?'delivered'
                                        :(loantype[index]=="pending")?'pending'
                                        :'returning',
                                        style: GoogleFonts.montserrat(
                                              color: Colors.white,
                                              fontSize: _mediaQueryWidth/60,
                                              fontWeight: FontWeight.w600
                                            ),
                                      ) ,
                               )          
                        
                        
                        
                        
                        
                            ],
                          ) ,
                        ),

                        Container(
                          height: 1,color: ColorPalette.SH_Grey500,
                        )
                      ],
                    );
                  },
                  ),
              )

      
              ],
          ),
        ),
      ),
    );
    }
}