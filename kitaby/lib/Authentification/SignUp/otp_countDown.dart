// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class otpcountDown extends StatefulWidget {
  const otpcountDown({
    Key? key,
    required this.deadline,
    required this.fontSize,
    required this.color,
    required this.fontWeight,
    this.textStyle,
    this.labelTextStyle,
  }) : super(key: key);

  final DateTime deadline;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  State<otpcountDown> createState() => _otpcountDownState();
}

class _otpcountDownState extends State<otpcountDown> {
  late Timer timer;
  Duration duration = const Duration();

  @override
  void initState() {
    calculateTimeLeft(widget.deadline);

    timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => calculateTimeLeft(widget.deadline),
    );
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textStyle = GoogleFonts.montserrat(
      color: widget.color,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
    final seconds = DefaultTextStyle(
      style: textStyle,
      child: Text(duration.inSeconds.toString().padLeft(2, '0')),
    );

    return Padding(
      padding: const EdgeInsets.all(6.5),
      child: seconds,
    );
  }

  void calculateTimeLeft(DateTime deadline) {
    final seconds = deadline.difference(DateTime.now()).inSeconds;
    setState(() {
      duration = Duration(seconds: seconds > 0 ? seconds : 0);
    });
  }
}
