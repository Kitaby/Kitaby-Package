import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/validator.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Mybooks/Mybooks.dart';
import 'package:kitabylib/models/Addbooklibresponsemodel.dart';
import 'package:kitabylib/models/api_services.dart';
import 'package:kitabylib/models/getavailablebooksmodel.dart';
import 'package:regexed_validator/regexed_validator.dart';

class confirmcode extends StatefulWidget {
  final String type;
  final String id;
 
  const confirmcode({super.key, required this.type, required this.id,});
@override
  State<confirmcode> createState() => confirmcodestate();
}



class confirmcodestate extends State<confirmcode> {


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
      _mediaQueryHeight = mediaQueryData.size.height;
    });
  }


static bool state = false;

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    _codecontroller.addListener(() {
      if(_codecontroller.value.text.isNotEmpty&&Fieldvalidator.iscodeValid(_codecontroller.value.text)){
        setState(() {
          canadd=true;
        });
      }else{
        setState(() {
          canadd=false;
        });
      }
    });
    
  }


bool canadd=false;
 final TextEditingController _codecontroller=TextEditingController();
 

@override
  Widget build(BuildContext context) {
    return Dialog(
     shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
     child: SizedBox(
      height: _mediaQueryHeight*(2/3),
      width: _mediaQueryWidth/2,

       child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
           
           const Image(image: AssetImage("assets/images/Barcode-rafiki.png")),
     
           WidgetsModels.Container_widget(300,null,null,EdgeInsets.only(bottom: 20),null,Text((widget.type=="give")?'You are sure that the user came to take his book ? Please enter the code givin by the user  ':'You are sure that the user came to return his book ? Please enter the code givin by the user ',style: GoogleFonts.montserrat(color: ColorPalette.SH_Grey900,fontWeight:FontWeight.w600,fontSize: 16.5 ),textAlign: TextAlign.center,)),
           
           Column(
             children: [
               WidgetsModels.Container_widget(null,null,Alignment.centerLeft,EdgeInsets.symmetric(horizontal: 30,vertical:5),null,Text('code',style: GoogleFonts.montserrat(color: ColorPalette.SH_Grey900,fontWeight:FontWeight.w600,fontSize: 10 ),textAlign: TextAlign.center,)),
               Padding(
             padding: const EdgeInsets.symmetric(horizontal:20),
             child: TextFormField(
              controller:_codecontroller ,
              keyboardType: TextInputType.number,
              cursorColor: ColorPalette.SH_Grey900,
              validator: Fieldvalidator.validatecode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLength: 6,
              style: GoogleFonts.montserrat(fontSize:15,fontWeight: FontWeight.w500,color: ColorPalette.SH_Grey500 ),
              decoration: InputDecoration(
                  counterText: '',
                  errorStyle: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: ColorPalette.Error,
                      fontWeight: FontWeight.w500),
                  prefixIcon: Align(
                    heightFactor: 1.0,
                    widthFactor: 1.0,
                    child: Icon(
                      FluentIcons.barcode_scanner_24_filled,
                      color: ColorPalette.SH_Grey900,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorPalette.SH_Grey900, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorPalette.Error, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorPalette.Error, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorPalette.SH_Grey900, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorPalette.SH_Grey900, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: ColorPalette.SH_Grey900, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            
             ],
           ),
           
            Padding(
             padding:  EdgeInsets.all(20),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: WidgetsModels.button1(130, 35, ColorPalette.Error, FluentIcons.calendar_cancel_16_filled, ColorPalette.SH_Grey100, "Cancel")),
                


                if(canadd==true)
                GestureDetector(
                  onTap:()async {
                    if(widget.type=="give"){
                      await APISERVICES().givebook( widget.id,_codecontroller.value.text);
                     }
                    else{
                      await APISERVICES().returnbook( widget.id,_codecontroller.value.text);
                     } 
                             
                   Navigator.pop(context);
                  } ,
                  child: WidgetsModels.button1(130, 35, ColorPalette.Secondary_Color_Orignal, FluentIcons.arrow_clockwise_dashes_16_filled, ColorPalette.SH_Grey100, "Confirm")
                  )
                else WidgetsModels.button1(130, 35, ColorPalette.SH_Grey500, FluentIcons.arrow_clockwise_dashes_16_filled, ColorPalette.SH_Grey300, "Confirm") 




             ],),
           )

       ],),
     ),
    );



    }
  }