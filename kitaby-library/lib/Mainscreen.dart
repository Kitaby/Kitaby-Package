import 'package:flutter/material.dart';
import 'package:kitabylib/Notifications/BooksOnLoan.dart';
import 'package:kitabylib/Dashbord/DashBoard.dart';
import 'package:kitabylib/Mybooks/Mybooks.dart';
import 'package:kitabylib/Notifications/ExpiredBooks.dart';
import 'package:kitabylib/Notifications/LoanRequests.dart';
import 'package:kitabylib/Notifications/PendingBooks.dart';
import 'package:kitabylib/Notifications/RenewRequests.dart';
import 'package:kitabylib/SideBarMenu.dart';

class Mainscreen extends StatefulWidget{
  final String? token;
  const Mainscreen({super.key, required this.token});

 @override
  State<Mainscreen> createState()  => MainscreenState();
  }
  
class MainscreenState extends State<Mainscreen>{

  Map screens = {
    0 :const DashBoard(),
    1 :const Mybooks(),
    2 :const LoanRequests(),
    3 : const PendingBooks(),
    4 : const BooksOnLoan(),
    5 : const ExpiredBooks(),
    6 : const RenewRequests(),
  };

 

static  ValueNotifier<int> currentscreen =ValueNotifier<int>(0);


@override
  void initState() {
    super.initState();
    currentscreen.addListener(() { if(mounted){setState(() { });}});
  }


  @override
  Widget build(BuildContext context) {
   return  Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            const Expanded(
              flex: 1,
              child:SideBarMenu(), 
            ),
            Expanded(
              flex: 5,
              child: screens[currentscreen.value], 
            ),
          ],
        )),
    );
  }
}