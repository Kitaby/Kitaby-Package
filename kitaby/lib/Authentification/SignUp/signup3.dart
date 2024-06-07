import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Constants/Path.dart';
import 'package:kitaby/Constants/Strings.dart';
import 'package:kitaby/Constants/routesnames.dart';
import 'package:kitaby/Constants/widgets.dart';
import '../../models/api_services.dart';
import '../../models/Authentification/Register/register_request_model.dart';

class Signup3 extends StatefulWidget {
  final String? name;
  final String? phone;
  final String? email;
  final String? password;
  const Signup3({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });

  @override
  State<Signup3> createState() => _Signup3State();
}

class _Signup3State extends State<Signup3> {
  List<String> categoriesselected = [];
  bool isStreched = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette.backgroundcolor,
      body: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          WidgetsModels.Container_widget(
            null,
            null,
            Alignment.topLeft,
            const EdgeInsets.only(top: 10, left: 25).w,
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
          Container(
              margin: const EdgeInsets.only(bottom: 10).w,
              child: Center(child: Image.asset(Path.LogoImg))),
          WidgetsModels.Container_widget(
              null,
              40.h,
              Alignment.center,
              null,
              null,
              Text(
                TextString.welcomehere,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w600),
              )),
          WidgetsModels.Container_widget(
              null,
              25.h,
              Alignment.center,
              null,
              null,
              Text(
                TextString.signupc,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w300),
              )),
          WidgetsModels.Container_widget(
              null,
              null,
              Alignment.center,
              const EdgeInsets.symmetric(vertical: 30).w,
              null,
              Image.asset(Path.Selected3)),
          WidgetsModels.Container_widget(
              null,
              null,
              Alignment.center,
              const EdgeInsets.symmetric(horizontal: 25).w,
              null,
              Text(
                TextString.categorycontent1,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700),
              )),
          WidgetsModels.Container_widget(
              null,
              null,
              Alignment.center,
              const EdgeInsets.symmetric(horizontal: 25).w,
              null,
              Text(
                TextString.categorycontent2,
                style: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700),
              )),
          Container(
              height: 250.h,
              margin: const EdgeInsets.symmetric(vertical: 25).w,
              padding: const EdgeInsets.symmetric(horizontal: 40).w,
              child: ListView.builder(
                itemCount: TextString.category.length,
                itemBuilder: (context, index) {
                  return WidgetsModels.customcard1(
                    TextString.category[index],
                    categoriesselected.contains(TextString.category[index]),
                    () {
                      setState(() {
                        if (!categoriesselected
                            .contains(TextString.category[index])) {
                          categoriesselected.add(TextString.category[index]);
                        } else {
                          categoriesselected.remove(TextString.category[index]);
                        }
                      });
                    },
                  );
                },
              )),
          if (categoriesselected.isNotEmpty)
            StatefulBuilder(
              builder: (contextbtn, setStatebtn) => GestureDetector(
                  onTap: () async {
                    setStatebtn(() {
                      isStreched = false;
                    });
                    RegisterRequestModel signup = RegisterRequestModel(
                      email: widget.email!,
                      password: widget.password!,
                      phone: widget.phone!,
                      name: widget.name!,
                      categories: categoriesselected,
                    );
                    await Future.delayed(const Duration(seconds: 1));
                    await APISERVICES().signup(signup).then((response) => {
                          setStatebtn(() {
                            isStreched = true;
                          }),
                          if (response.message == "success")
                            {
                              context.pop(),
                              context.pop(),
                              context
                                  .pushReplacementNamed(RoutesName.EmailVerif),
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
                          const EdgeInsets.symmetric(horizontal: 40).w,
                          BoxDecoration(
                            color: ColorPalette.SH_Grey100,
                            borderRadius: BorderRadius.circular(5).r,
                          ),
                          Text(
                            TextString.signup3,
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
                const EdgeInsets.only(left: 40, right: 40, bottom: 20).w,
                BoxDecoration(
                  color: ColorPalette.SH_Grey500,
                  borderRadius: BorderRadius.circular(5).r,
                ),
                Text(
                  'Sign up',
                  style: GoogleFonts.montserrat(
                      color: ColorPalette.SH_Grey900,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700),
                )),
        ],
      ),
    );
  }
}
