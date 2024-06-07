
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kitabylib/AppIntro/Intro-1.dart';
import 'package:kitabylib/AppIntro/Intro-2.dart';
import 'package:kitabylib/AppIntro/Intro-3.dart';
import 'package:kitabylib/AppIntro/SplashScreen.dart';

import 'package:kitabylib/Mainscreen.dart';

import 'package:window_manager/window_manager.dart';
import 'package:kitabylib/Forgotyourpassword/forgotyourpassword.dart';

import 'package:kitabylib/SignUp/SignUp1.dart';
import 'package:kitabylib/SignUp/SignUp2.dart';
import 'package:kitabylib/SignUp/SignUp3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(

      //center: true,

      windowButtonVisibility: true,
      size: Size(1440, 900),
      minimumSize: Size(960, 720),
      titleBarStyle: TitleBarStyle.normal,
      title: 'Kitabylib');
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,designSize: const Size(1440,750));
    return MaterialApp(
      title: 'Kitabylib',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        'Mainscreen': (context) => Mainscreen(token: "",),
        'Forgotyourpassword': (context) =>
            const Forgotyourpassword(oldmail: ""),
        'Intro1': (context) => Intro1(),
        'Intro2': (context) => Intro2(),
        'Intro3': (context) => Intro3(),
        'SignUp1': (context) => SignUp1(),
        'SignUp2': (context) => Signup2(phone: "", name: ""),
        'SignUp3': (context) =>
            Signup3(phone: "", email: "", password: "", name: ""),
      },
    );
  }
}
