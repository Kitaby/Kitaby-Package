// ignore_for_file: camel_case_types

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class countDown extends StatefulWidget {
  const countDown({
    super.key,
    required this.deadline,
    required this.fontSize ,
    required this.color,
    required this.fontWeight,
    this.textStyle,
    this.labelTextStyle,
  });

  final DateTime deadline;
  final TextStyle? textStyle;
  final TextStyle? labelTextStyle;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  @override
  State<countDown> createState() => _countDownState();
}

class _countDownState extends State<countDown> {
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

    var labelTextStyle = GoogleFonts.montserrat(
      color: widget.color,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );

    final days = DefaultTextStyle(
      style: textStyle,
      child: Text(duration.inDays.toString().padLeft(2, '0')),
    );

    final hours = DefaultTextStyle(
      style: textStyle,
      child: Text(duration.inHours.remainder(24).toString().padLeft(2, '0')),
    );

    final minutes = DefaultTextStyle(
      style: textStyle,
      child: Text(duration.inMinutes.remainder(60).toString().padLeft(2, '0')),
    );

    final seconds = DefaultTextStyle(
      style: textStyle,
      child: Text(duration.inSeconds.remainder(60).toString().padLeft(2, '0')),
    );

    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        DefaultTextStyle(
          style: labelTextStyle,
          child: const Text("Time Left :"),
        ),
        Padding(
          padding: const EdgeInsets.all(6.5),
          child: days,
        ),
        DefaultTextStyle(style: labelTextStyle, child: const Text(" : ")),
        Padding(
          padding: const EdgeInsets.all(6.5),
          child: hours,
        ),
        DefaultTextStyle(style: labelTextStyle, child: const Text(" : ")),
        Padding(
          padding: const EdgeInsets.all(6.5),
          child: minutes,
        ),
        DefaultTextStyle(style: labelTextStyle, child: const Text(" : ")),
        Padding(
          padding: const EdgeInsets.all(6.5),
          child: seconds,
        ),
      ],
    );
  }

  void calculateTimeLeft(DateTime deadline) {
    final seconds = deadline.difference(DateTime.now()).inSeconds;
    setState(() {
      duration = Duration(seconds: seconds > 0 ? seconds : 0);
    });
  }
}
