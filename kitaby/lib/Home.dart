// ignore_for_file: file_names

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:kitaby/Constants/Colors.dart';
import 'package:kitaby/Exchange/User-Exchange.dart';
import 'package:kitaby/Reservation/User-Reservation.dart';
import 'package:kitaby/profile/Profile.dart';
import 'Community/Home.dart';
import 'Recommendation/RecommendationHome.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Home extends StatefulWidget {
  final String? token;
  final int index;
  const Home({super.key, required this.token, required this.index});

  @override
  State<Home> createState() => Homestate();
}

class Homestate extends State<Home> {
  late IO.Socket socket;
  late int _selectedIndex = widget.index;
  static const List<Widget> _widgets = <Widget>[
    RecommendationHome(),
    userreservation(),
    userexchange(),
    HomeCommunity(),
    Profile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void connect() {
    socket = IO.io("http://192.168.2.106:4000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) => {print("Connected")});
    socket.emit("addNewUser", widget.token);
  }

  @override
  void initState() {
    print(widget.token);
    connect();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgets.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        color: ColorPalette.Primary_Color_Original,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13.5),
          child: GNav(
            selectedIndex: _selectedIndex,
            gap: 4,
            backgroundColor: ColorPalette.Primary_Color_Original,
            tabBackgroundColor: ColorPalette.Secondary_Color_Orignal,
            padding: const EdgeInsets.all(12),
            tabs: [
              GButton(
                icon: FluentIcons.home_24_regular,
                iconSize: 24,
                iconColor: ColorPalette.SH_Grey100,
                iconActiveColor: ColorPalette.SH_Grey100,
                text: "Home",
                textStyle: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                onPressed: () {
                  _onItemTapped(0);
                },
              ),
              GButton(
                icon: FluentIcons.clock_24_regular,
                iconSize: 24,
                iconColor: ColorPalette.SH_Grey100,
                iconActiveColor: ColorPalette.SH_Grey100,
                text: "Loan",
                textStyle: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                onPressed: () {
                  _onItemTapped(1);
                },
              ),
              GButton(
                icon: FluentIcons.people_swap_24_regular,
                iconSize: 24,
                iconColor: ColorPalette.SH_Grey100,
                iconActiveColor: ColorPalette.SH_Grey100,
                text: "Trade",
                textStyle: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                onPressed: () {
                  _onItemTapped(2);
                },
              ),
              GButton(
                icon: FluentIcons.people_community_24_regular,
                iconSize: 24,
                iconColor: ColorPalette.SH_Grey100,
                iconActiveColor: ColorPalette.SH_Grey100,
                text: "Groups",
                textStyle: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                onPressed: () {
                  _onItemTapped(3);
                },
              ),
              GButton(
                icon: FluentIcons.person_24_regular,
                iconSize: 24,
                iconColor: ColorPalette.SH_Grey100,
                iconActiveColor: ColorPalette.SH_Grey100,
                text: "Profile",
                textStyle: GoogleFonts.montserrat(
                    color: ColorPalette.SH_Grey100,
                    fontSize: 15,
                    fontWeight: FontWeight.w600),
                onPressed: () {
                  _onItemTapped(4);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
