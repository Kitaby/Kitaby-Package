// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/validator.dart';
import 'package:kitaby/Constants/widgets.dart';
import 'package:kitaby/Constants/Path.dart';
import 'package:kitaby/models/Authentification/ForgotPassword/forgot_password_request_model.dart';
import 'package:regexed_validator/regexed_validator.dart';
import '../../models/api_services.dart';

class Forgotyourpassword extends StatefulWidget {
  final String? oldmail;
  const Forgotyourpassword({super.key, required this.oldmail});
  @override
  State<Forgotyourpassword> createState() => Forgotyourpasswordstate();
}

class Forgotyourpasswordstate extends State<Forgotyourpassword> {
  final _forgotemailController = TextEditingController();
  static GlobalKey<FormState> forgotyourpassword = GlobalKey();
  static bool state = false;
  static bool isStreched = true;
  @override
  void initState() {
    super.initState();
    if (widget.oldmail != " ") {
      _forgotemailController.text = widget.oldmail!;
    } else {
      _forgotemailController.text = '';
    }
    _forgotemailController.addListener(() {
      final isEmailValid = validator.email(_forgotemailController.value.text);
      if (isEmailValid != state) {
        setState(() {
          state = isEmailValid;
        });
      }
    });
  }

  @override
  void dispose() {
    _forgotemailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: ListView(physics: const NeverScrollableScrollPhysics(), children: [
        WidgetsModels.Container_widget(
          null,
          null,
          Alignment.topLeft,
          const EdgeInsets.all(20).w,
          null,
          GestureDetector(
              onTap: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
              child: Icon(
                Icons.arrow_back_rounded,
                size: 30.sp,
                color: ColorPalette.SH_Grey100,
              )),
        ),
        WidgetsModels.Container_widget(null, null, Alignment.center,
            const EdgeInsets.only(bottom: 35).w, null, Image.asset(Path.LogoImg)),
        WidgetsModels.Container_widget(
            null,
            40.h,
            Alignment.center,
            const EdgeInsets.only(bottom: 10).w,
            null,
            Text(
              TextString.forgotpassword,
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700),
            )),
        WidgetsModels.Container_widget(
            null,
            25.h,
            Alignment.center,
            const EdgeInsets.only(bottom: 15).w,
            null,
            Text(
              TextString.forgotpasswordcontent,
              style: GoogleFonts.montserrat(
                  color: ColorPalette.SH_Grey100,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500),
            )),
        Form(
            key: forgotyourpassword,
            child: Container(
              height: 130.h,
              margin: const EdgeInsets.only(top: 35).w,
              padding: const EdgeInsets.symmetric(horizontal: 25).w,
              child: WidgetsModels.customTTF_title(
                  TextString.emailadress,
                  null,
                  _forgotemailController,
                  TextInputType.emailAddress,
                  Fieldvalidator.validateemail,
                  Icon(
                    Icons.mail_outline_outlined,
                    color: ColorPalette.SH_Grey100,
                    size: 20.sp,
                  ),
                  null,
                  false,
                  null),
            )),
        if (validator.email(_forgotemailController.value.text))
          StatefulBuilder(
            builder: (contextbtn, setStatebtn) => GestureDetector(
                onTap: () async {
                  setStatebtn(() {
                    isStreched = false;
                  });
                  ForgotPasswordRequestModel ForgotPassword =
                      ForgotPasswordRequestModel(
                    email: _forgotemailController.value.text,
                  );
                  await Future.delayed(const Duration(seconds: 1));
                  await APISERVICES()
                      .forgetPassword(ForgotPassword)
                      .then((response) => {
                            setStatebtn(() {
                              isStreched = true;
                            }),
                            if (response.message == "success")
                              {
                                context.pop(),
                                context.pushReplacementNamed(
                                    RoutesName.ForgetPasswordAnime,
                                    pathParameters: {
                                      'email': _forgotemailController.value.text
                                    }),
                              }
                            else if (response.message == "user not found")
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    WidgetsModels.Dialog_Message(
                                        "fail",
                                        response.message,
                                        "Please enter a valid email ")),
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
                        null,
                        50.h,
                        Alignment.center,
                        const EdgeInsets.all(25).w,
                        BoxDecoration(
                          color: ColorPalette.SH_Grey100,
                          borderRadius: BorderRadius.circular(5).r,
                        ),
                        Text(
                          TextString.sendrequest,
                          style: GoogleFonts.montserrat(
                              color: ColorPalette.SH_Grey900,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      )
                    : WidgetsModels.buildSmallButton()),
          )
        else
          WidgetsModels.Container_widget(
              null,
              50.h,
              Alignment.center,
              const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 25,
              ).w,
              BoxDecoration(
                color: ColorPalette.SH_Grey500,
                borderRadius: BorderRadius.circular(5).r,
              ),
              Text(
                TextString.sendrequest,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey900,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700),
              )),
      ]),
    );
  }
}
