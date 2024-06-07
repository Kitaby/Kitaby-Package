
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/Animations/EmailVerif.dart';
import 'package:kitabylib/Constants/validator.dart';
import 'package:kitabylib/Constants/widgets.dart';
import 'package:kitabylib/Constants/Colors.dart';
import 'package:kitabylib/Constants/Path.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

import '../models/api_services.dart';
import '../models/auth/signUp_request.dart';

class Signup3 extends StatefulWidget {
  const Signup3({
    super.key,
    required this.phone,
    required this.email,
    required this.password,
    required this.name,
  });
  final String phone;
  final String email;
  final String password;
  final String name;

  @override
  State<Signup3> createState() => _Signup3State();
}

class _Signup3State extends State<Signup3> {


  static bool state4 = false;
  static bool state5 = false;
  static bool state6 = false;
  bool isStreched = true;
  static GlobalKey<FormState> Signup = GlobalKey();

  final _libNameController = TextEditingController();
  final _commercialRegisterNumberController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _libNameController.addListener(() {
      final isnameValid = Fieldvalidator.libName(_libNameController.value.text);
      if (isnameValid != state4) {
        setState(() {
          state4 = isnameValid;
        });
      }
    });

    _commercialRegisterNumberController.addListener(() {
      final iscrnValid = Fieldvalidator.iscrnvalid(_commercialRegisterNumberController.value.text);
      if (iscrnValid != state5) {
        setState(() {
          state5 = iscrnValid;
        });
      }
    });

    _addressController.addListener(() {
      final isAddressValid = Fieldvalidator.libName(_addressController.value.text);
      if (isAddressValid != state6) {
        setState(() {
          state6 = isAddressValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _libNameController.dispose();
    _commercialRegisterNumberController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration:const BoxDecoration(
          image : DecorationImage(image: AssetImage("assets/images/Shape.png"), fit: BoxFit.cover),
        ),
        child: Container(
          height: 665.h,
          width: 456.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24).w,
            color: ColorPalette.SH_Grey100,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 25 , vertical: 10).w,
          child: ListView(
            //physics: const NeverScrollableScrollPhysics(),
            children: [
              Center(child: Image.asset(Path.Logolib)),
              WidgetsModels.Container_widget(
                  null,
                  40.h,
                  Alignment.center,
                  null,
                  null,
                  Text(
                    'Welcome Here',
                    style: GoogleFonts.montserrat(
                        color: ColorPalette.backgroundcolor,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w600),
                  )),
              WidgetsModels.Container_widget(
                null,
                25.h,
                Alignment.center,
                const EdgeInsets.only(bottom: 15).w,
                null,
                Text(
                  'Sign to continue',
                  style: GoogleFonts.montserrat(
                    color: ColorPalette.backgroundcolor,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w300),
                )),
              WidgetsModels.Container_widget(
                  null,
                  30.h,
                  Alignment.center,
                  null,
                  null,
                  Image.asset(Path.Selected3)
              ),
              Form(
                key: Signup,
                child: Column(
                  children: [
                    WidgetsModels.customTTF_title(
                      "Library Name",
                      null,
                      _libNameController,
                      TextInputType.name,
                      Fieldvalidator.validateLibname,
                      Icon(
                        FluentIcons.mail_24_regular,
                        color: ColorPalette.backgroundcolor,
                      ),
                      null,
                      false,
                      null
                    ),
                    WidgetsModels.customTTF_title(
                      "Commercial Register Number",
                      null,
                      _commercialRegisterNumberController,
                      TextInputType.number,
                      Fieldvalidator.validatecrn,
                      Icon(
                        FluentIcons.barcode_scanner_24_regular,
                        color: ColorPalette.backgroundcolor,
                      ),
                      null,
                      false,
                      10
                    ),
                    WidgetsModels.customTTF_title(
                      "Address",
                      null,
                      _addressController,
                      TextInputType.number,
                      Fieldvalidator.validateaddres,
                      Icon(
                        FluentIcons.location_24_regular,
                        color: ColorPalette.backgroundcolor,
                      ),
                      null,
                      false,
                      10
                    ),
                  ],
                )
              ),
              if (state4&&state5&&state6
                )
                StatefulBuilder(
                  builder: (contextbtn, setStatebtn) => GestureDetector(
                    onTap: () async {
                      setStatebtn(() {
                        isStreched = false;
                      });
                    SignupRequest signup = SignupRequest(
                      email: widget.email,
                      password: widget.password,
                      phone: widget.phone,
                      name: widget.name,
                      address: _addressController.value.text,
                      comRegNum: _commercialRegisterNumberController.value.text
                    );
                    await Future.delayed(const Duration(seconds: 1));
                    await APISERVICES().signup(signup).then((response) => {
                          setStatebtn(() {
                            isStreched = true;
                          }),
                          if (response.message == "success")
                            {
                              Navigator.pop(context),
                              Navigator.pop(context),
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const EmailVerif(),)
                              )
                            }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  WidgetsModels.Dialog_Message("fail",
                                      "Unkwon error", "Please retry later")),
                            }
                        });
                  },
                  child: isStreched
                      ? WidgetsModels.Container_widget(
                          50.w,
                          45.h,
                          Alignment.center,
                          const EdgeInsets.symmetric(horizontal: 30 , vertical: 15).w,
                          BoxDecoration(
                            color: ColorPalette.backgroundcolor,
                            borderRadius: BorderRadius.circular(5).r,
                          ),
                          Text(
                            "SignUp",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w700),
                          ),
                        )
                      : WidgetsModels.buildSmallButton()),
                )
                  else
                    WidgetsModels.Container_widget(
                        50.w,
                        45.h,
                        Alignment.center,
                        const EdgeInsets.symmetric(horizontal: 30 , vertical: 15).w,
                        BoxDecoration(
                            color: ColorPalette.SH_Grey300,
                            borderRadius: BorderRadius.circular(5).r),
                        Text("SignUp",
                            style: GoogleFonts.montserrat(
                                color: ColorPalette.SH_Grey100,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w600))),
            ],
          ),
        ),
      ),
    );
  }
}
